import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';

@freezed
abstract class Country with _$Country {
  const factory Country({
    required int id,
    required String isoCode,
    required String nameEs,
    required String capitalEs,
    required String continent,
    required int difficulty,
    required String flagAssetPath,
  }) = _Country;
}
