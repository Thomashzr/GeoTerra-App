import 'package:audioplayers/audioplayers.dart';

/// Abstract contract for audio operations across the application.
abstract interface class IAudioService {
  /// Preloads audio sources to optimize latency upon initial playback.
  Future<void> preload();

  /// Plays feedback sound when an answer is correct.
  Future<void> playSuccess();

  /// Plays feedback sound when an answer is wrong.
  Future<void> playError();

  /// Plays a subtle tick sound for timer alerts.
  Future<void> playTick();

  /// Plays the game over sound when lives reach zero.
  Future<void> playGameOver();

  /// Releases audio resources.
  Future<void> dispose();
}

/// Lightweight audio service implementing [IAudioService] via [AudioPlayer].
///
/// Uses [PlayerMode.lowLatency] and reuses players to minimize memory and latency.
class AudioService implements IAudioService {
  AudioService({AudioPlayer? player, double initialVolume = 1})
    : _player = player ?? AudioPlayer(),
      _volume = initialVolume.clamp(0.0, 1.0).toDouble();

  final AudioPlayer _player;
  final double _volume;
  bool _isDisposed = false;

  static const String _successAsset = 'audio/success.mp3';
  static const String _errorAsset = 'audio/error.mp3';
  static const String _tickAsset = 'audio/tick.mp3';
  static const String _gameOverAsset = 'audio/game_over.mp3';

  @override
  Future<void> preload() async {
    if (_isDisposed) return;
    try {
      await _player.setPlayerMode(PlayerMode.lowLatency);
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setVolume(_volume);
      // Pre-warm the audio cache for instant playback
      await AudioCache.instance.loadAll([
        _successAsset,
        _errorAsset,
        _tickAsset,
        _gameOverAsset,
      ]);
    } catch (_) {
      // Gracefully ignore audio preloading errors on non-supported environments (e.g. testing)
    }
  }

  @override
  Future<void> playSuccess() => _playSound(_successAsset);

  @override
  Future<void> playError() => _playSound(_errorAsset);

  @override
  Future<void> playTick() => _playSound(_tickAsset);

  @override
  Future<void> playGameOver() => _playSound(_gameOverAsset);

  Future<void> _playSound(String assetPath) async {
    if (_isDisposed || _volume == 0) return;
    try {
      await _player.stop();
      await _player.setVolume(_volume);
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Avoid crashing gameplay if platform audio output fails
    }
  }

  @override
  Future<void> dispose() async {
    _isDisposed = true;
    try {
      await _player.dispose();
    } catch (_) {}
  }
}
