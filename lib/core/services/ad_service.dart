import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract interface class IAdService {
  Future<void> preload();

  Future<bool> showRewardedAd();

  Future<bool> showInterstitialIfEligible();

  Future<BannerAd?> loadBannerAd();

  Future<void> dispose();
}

class AdMobService implements IAdService {
  RewardedAd? _rewardedAd;
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;
  RewardedAd? _activeRewardedAd;
  InterstitialAd? _activeInterstitialAd;
  BannerAd? _loadingBannerAd;

  Future<bool>? _initializationFuture;
  Future<void>? _rewardedLoadFuture;
  Future<void>? _interstitialLoadFuture;
  Future<BannerAd?>? _bannerLoadFuture;
  Completer<void>? _rewardedLoadCompleter;
  Completer<void>? _interstitialLoadCompleter;
  Completer<BannerAd?>? _bannerLoadCompleter;
  Completer<bool>? _rewardedShowCompleter;
  Completer<bool>? _interstitialShowCompleter;

  var _completedGames = 0;
  var _isDisposed = false;
  var _rewardedShowing = false;
  var _interstitialShowing = false;

  @override
  Future<void> preload() async {
    if (!await _ensureInitialized()) {
      return;
    }

    await Future.wait([_loadRewardedAd(), _loadInterstitialAd()]);
  }

  @override
  Future<bool> showRewardedAd() async {
    if (_isDisposed || _rewardedShowing) {
      return false;
    }

    final ad = _rewardedAd;
    if (ad == null) {
      unawaited(_loadRewardedAd());
      return false;
    }

    _rewardedAd = null;
    _activeRewardedAd = ad;
    _rewardedShowing = true;

    var rewardEarned = false;
    final result = Completer<bool>();
    _rewardedShowCompleter = result;

    void finish(bool value) {
      if (result.isCompleted) {
        return;
      }

      _rewardedShowing = false;
      _activeRewardedAd = null;
      _rewardedShowCompleter = null;
      unawaited(ad.dispose());
      result.complete(value);

      if (!_isDisposed) {
        unawaited(_loadRewardedAd());
      }
    }

    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (_) => finish(rewardEarned),
      onAdFailedToShowFullScreenContent: (_, _) => finish(false),
    );

    try {
      await ad.show(
        onUserEarnedReward: (_, _) {
          rewardEarned = true;
        },
      );
    } catch (_) {
      finish(false);
    }

    return result.future;
  }

  @override
  Future<bool> showInterstitialIfEligible() async {
    if (_isDisposed) {
      return false;
    }

    _completedGames++;
    if (_completedGames % 3 != 0 || _interstitialShowing) {
      return false;
    }

    final ad = _interstitialAd;
    if (ad == null) {
      unawaited(_loadInterstitialAd());
      return false;
    }

    _interstitialAd = null;
    _activeInterstitialAd = ad;
    _interstitialShowing = true;

    final result = Completer<bool>();
    _interstitialShowCompleter = result;
    var isFinished = false;

    void finish({required bool shown}) {
      if (isFinished || (_isDisposed && result.isCompleted)) {
        return;
      }
      isFinished = true;

      if (!result.isCompleted) {
        result.complete(shown);
      }

      _interstitialShowing = false;
      _activeInterstitialAd = null;
      _interstitialShowCompleter = null;
      unawaited(ad.dispose());

      if (!_isDisposed) {
        unawaited(_loadInterstitialAd());
      }
    }

    ad.fullScreenContentCallback = FullScreenContentCallback<InterstitialAd>(
      onAdShowedFullScreenContent: (_) {
        if (!result.isCompleted) {
          result.complete(true);
        }
      },
      onAdDismissedFullScreenContent: (_) => finish(shown: true),
      onAdFailedToShowFullScreenContent: (_, _) => finish(shown: false),
    );

    try {
      await ad.show();
    } catch (_) {
      finish(shown: false);
    }

    return result.future;
  }

  @override
  Future<BannerAd?> loadBannerAd() {
    if (_isDisposed || !_isSupportedPlatform) {
      return Future.value();
    }

    final loadedAd = _bannerAd;
    if (loadedAd != null) {
      return Future.value(loadedAd);
    }

    final pendingLoad = _bannerLoadFuture;
    if (pendingLoad != null) {
      return pendingLoad;
    }

    final load = _loadBannerAd();
    _bannerLoadFuture = load;
    return load;
  }

  Future<BannerAd?> _loadBannerAd() async {
    if (!await _ensureInitialized()) {
      _bannerLoadFuture = null;
      return null;
    }

    final adUnitId = _bannerAdUnitId;
    if (adUnitId == null || _isDisposed) {
      _bannerLoadFuture = null;
      return null;
    }

    final loaded = Completer<BannerAd?>();
    _bannerLoadCompleter = loaded;
    late final BannerAd banner;
    banner = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _loadingBannerAd = null;
          if (_isDisposed) {
            unawaited(banner.dispose());
            if (!loaded.isCompleted) {
              loaded.complete(null);
            }
            return;
          }

          _bannerAd = banner;
          if (!loaded.isCompleted) {
            loaded.complete(banner);
          }
        },
        onAdFailedToLoad: (_, _) {
          _loadingBannerAd = null;
          unawaited(banner.dispose());
          if (!loaded.isCompleted) {
            loaded.complete(null);
          }
        },
      ),
    );
    _loadingBannerAd = banner;

    try {
      await banner.load();
    } catch (_) {
      _loadingBannerAd = null;
      unawaited(banner.dispose());
      if (!loaded.isCompleted) {
        loaded.complete(null);
      }
    }

    final result = await loaded.future;
    _bannerLoadCompleter = null;
    _bannerLoadFuture = null;
    return result;
  }

  Future<bool> _ensureInitialized() {
    if (_isDisposed || !_isSupportedPlatform) {
      return Future.value(false);
    }

    return _initializationFuture ??= _initialize();
  }

  Future<bool> _initialize() async {
    try {
      await _updateConsentInformation();
      if (!await ConsentInformation.instance.canRequestAds()) {
        return false;
      }

      await MobileAds.instance.initialize();
      return !_isDisposed;
    } catch (_) {
      return false;
    }
  }

  Future<void> _updateConsentInformation() async {
    final update = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        ConsentForm.loadAndShowConsentFormIfRequired((_) {
          if (!update.isCompleted) {
            update.complete();
          }
        });
      },
      (_) {
        if (!update.isCompleted) {
          update.complete();
        }
      },
    );

    await update.future;
  }

  Future<void> _loadRewardedAd() {
    final pendingLoad = _rewardedLoadFuture;
    if (pendingLoad != null) {
      return pendingLoad;
    }

    if (_isDisposed || _rewardedAd != null || _rewardedShowing) {
      return Future.value();
    }

    final load = _performRewardedLoad();
    _rewardedLoadFuture = load;
    return load;
  }

  Future<void> _performRewardedLoad() async {
    if (!await _ensureInitialized()) {
      _rewardedLoadFuture = null;
      return;
    }

    final adUnitId = _rewardedAdUnitId;
    if (adUnitId == null || _isDisposed) {
      _rewardedLoadFuture = null;
      return;
    }

    final loaded = Completer<void>();
    _rewardedLoadCompleter = loaded;
    try {
      await RewardedAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (ad) {
            if (_isDisposed || _rewardedAd != null) {
              unawaited(ad.dispose());
            } else {
              _rewardedAd = ad;
            }
            if (!loaded.isCompleted) {
              loaded.complete();
            }
          },
          onAdFailedToLoad: (_) {
            if (!loaded.isCompleted) {
              loaded.complete();
            }
          },
        ),
      );
    } catch (_) {
      if (!loaded.isCompleted) {
        loaded.complete();
      }
    }

    await loaded.future;
    _rewardedLoadCompleter = null;
    _rewardedLoadFuture = null;
  }

  Future<void> _loadInterstitialAd() {
    final pendingLoad = _interstitialLoadFuture;
    if (pendingLoad != null) {
      return pendingLoad;
    }

    if (_isDisposed || _interstitialAd != null || _interstitialShowing) {
      return Future.value();
    }

    final load = _performInterstitialLoad();
    _interstitialLoadFuture = load;
    return load;
  }

  Future<void> _performInterstitialLoad() async {
    if (!await _ensureInitialized()) {
      _interstitialLoadFuture = null;
      return;
    }

    final adUnitId = _interstitialAdUnitId;
    if (adUnitId == null || _isDisposed) {
      _interstitialLoadFuture = null;
      return;
    }

    final loaded = Completer<void>();
    _interstitialLoadCompleter = loaded;
    try {
      await InterstitialAd.load(
        adUnitId: adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            if (_isDisposed || _interstitialAd != null) {
              unawaited(ad.dispose());
            } else {
              _interstitialAd = ad;
            }
            if (!loaded.isCompleted) {
              loaded.complete();
            }
          },
          onAdFailedToLoad: (_) {
            if (!loaded.isCompleted) {
              loaded.complete();
            }
          },
        ),
      );
    } catch (_) {
      if (!loaded.isCompleted) {
        loaded.complete();
      }
    }

    await loaded.future;
    _interstitialLoadCompleter = null;
    _interstitialLoadFuture = null;
  }

  @override
  Future<void> dispose() async {
    if (_isDisposed) {
      return;
    }

    _isDisposed = true;
    _rewardedShowing = false;
    _interstitialShowing = false;

    if (!(_rewardedShowCompleter?.isCompleted ?? true)) {
      _rewardedShowCompleter!.complete(false);
    }
    if (!(_interstitialShowCompleter?.isCompleted ?? true)) {
      _interstitialShowCompleter!.complete(false);
    }
    _rewardedShowCompleter = null;
    _interstitialShowCompleter = null;

    if (!(_rewardedLoadCompleter?.isCompleted ?? true)) {
      _rewardedLoadCompleter!.complete();
    }
    if (!(_interstitialLoadCompleter?.isCompleted ?? true)) {
      _interstitialLoadCompleter!.complete();
    }
    if (!(_bannerLoadCompleter?.isCompleted ?? true)) {
      _bannerLoadCompleter!.complete(null);
    }
    _rewardedLoadCompleter = null;
    _interstitialLoadCompleter = null;
    _bannerLoadCompleter = null;

    final ads = <Ad>{
      if (_rewardedAd case final ad?) ad,
      if (_interstitialAd case final ad?) ad,
      if (_bannerAd case final ad?) ad,
      if (_activeRewardedAd case final ad?) ad,
      if (_activeInterstitialAd case final ad?) ad,
      if (_loadingBannerAd case final ad?) ad,
    };

    _rewardedAd = null;
    _interstitialAd = null;
    _bannerAd = null;
    _activeRewardedAd = null;
    _activeInterstitialAd = null;
    _loadingBannerAd = null;

    await Future.wait(
      ads.map((ad) async {
        try {
          await ad.dispose();
        } catch (_) {
          // Platform teardown must never crash application shutdown.
        }
      }),
    );
  }

  bool get _isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  String? get _bannerAdUnitId => _adUnitId(
    androidTestId: _androidBannerTestId,
    iosTestId: _iosBannerTestId,
    androidReleaseId: _androidBannerReleaseId,
    iosReleaseId: _iosBannerReleaseId,
  );

  String? get _interstitialAdUnitId => _adUnitId(
    androidTestId: _androidInterstitialTestId,
    iosTestId: _iosInterstitialTestId,
    androidReleaseId: _androidInterstitialReleaseId,
    iosReleaseId: _iosInterstitialReleaseId,
  );

  String? get _rewardedAdUnitId => _adUnitId(
    androidTestId: _androidRewardedTestId,
    iosTestId: _iosRewardedTestId,
    androidReleaseId: _androidRewardedReleaseId,
    iosReleaseId: _iosRewardedReleaseId,
  );

  String? _adUnitId({
    required String androidTestId,
    required String iosTestId,
    required String androidReleaseId,
    required String iosReleaseId,
  }) {
    if (!_isSupportedPlatform) {
      return null;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      final value = kReleaseMode ? androidReleaseId : androidTestId;
      return value.isEmpty ? null : value;
    }

    final value = kReleaseMode ? iosReleaseId : iosTestId;
    return value.isEmpty ? null : value;
  }

  // Official Google sample ad units. Never use production IDs outside release.
  static const _androidBannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const _androidInterstitialTestId =
      'ca-app-pub-3940256099942544/1033173712';
  static const _androidRewardedTestId =
      'ca-app-pub-3940256099942544/5224354917';
  static const _iosBannerTestId = 'ca-app-pub-3940256099942544/2934735716';
  static const _iosInterstitialTestId =
      'ca-app-pub-3940256099942544/4411468910';
  static const _iosRewardedTestId = 'ca-app-pub-3940256099942544/1712485313';

  static const _androidBannerReleaseId = String.fromEnvironment(
    'ADMOB_ANDROID_BANNER_AD_UNIT_ID',
  );
  static const _androidInterstitialReleaseId = String.fromEnvironment(
    'ADMOB_ANDROID_INTERSTITIAL_AD_UNIT_ID',
  );
  static const _androidRewardedReleaseId = String.fromEnvironment(
    'ADMOB_ANDROID_REWARDED_AD_UNIT_ID',
  );
  static const _iosBannerReleaseId = String.fromEnvironment(
    'ADMOB_IOS_BANNER_AD_UNIT_ID',
  );
  static const _iosInterstitialReleaseId = String.fromEnvironment(
    'ADMOB_IOS_INTERSTITIAL_AD_UNIT_ID',
  );
  static const _iosRewardedReleaseId = String.fromEnvironment(
    'ADMOB_IOS_REWARDED_AD_UNIT_ID',
  );
}
