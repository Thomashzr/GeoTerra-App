// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'country.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Country {

 int get id; String get isoCode; String get nameEs; String get capitalEs; String get continent; int get difficulty; String get flagAssetPath;
/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CountryCopyWith<Country> get copyWith => _$CountryCopyWithImpl<Country>(this as Country, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Country;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Country&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.isoCode, _this.isoCode) || other.isoCode == _this.isoCode)&&(identical(other.nameEs, _this.nameEs) || other.nameEs == _this.nameEs)&&(identical(other.capitalEs, _this.capitalEs) || other.capitalEs == _this.capitalEs)&&(identical(other.continent, _this.continent) || other.continent == _this.continent)&&(identical(other.difficulty, _this.difficulty) || other.difficulty == _this.difficulty)&&(identical(other.flagAssetPath, _this.flagAssetPath) || other.flagAssetPath == _this.flagAssetPath));
}


@override
int get hashCode {
  final _this = this as Country;
  return Object.hash(runtimeType,_this.id,_this.isoCode,_this.nameEs,_this.capitalEs,_this.continent,_this.difficulty,_this.flagAssetPath);
}

@override
String toString() {
  final _this = this as Country;
  return 'Country(id: ${_this.id}, isoCode: ${_this.isoCode}, nameEs: ${_this.nameEs}, capitalEs: ${_this.capitalEs}, continent: ${_this.continent}, difficulty: ${_this.difficulty}, flagAssetPath: ${_this.flagAssetPath})';
}


}

/// @nodoc
abstract mixin class $CountryCopyWith<$Res>  {
  factory $CountryCopyWith(Country value, $Res Function(Country) _then) = _$CountryCopyWithImpl;
@useResult
$Res call({
 int id, String isoCode, String nameEs, String capitalEs, String continent, int difficulty, String flagAssetPath
});




}
/// @nodoc
class _$CountryCopyWithImpl<$Res>
    implements $CountryCopyWith<$Res> {
  _$CountryCopyWithImpl(this._self, this._then);

  final Country _self;
  final $Res Function(Country) _then;

/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isoCode = null,Object? nameEs = null,Object? capitalEs = null,Object? continent = null,Object? difficulty = null,Object? flagAssetPath = null,}) {
  return _then(Country(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isoCode: null == isoCode ? _self.isoCode : isoCode // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,capitalEs: null == capitalEs ? _self.capitalEs : capitalEs // ignore: cast_nullable_to_non_nullable
as String,continent: null == continent ? _self.continent : continent // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,flagAssetPath: null == flagAssetPath ? _self.flagAssetPath : flagAssetPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Country].
extension CountryPatterns on Country {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Country value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Country() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Country value)  $default,){
final _that = this;
switch (_that) {
case _Country():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Country value)?  $default,){
final _that = this;
switch (_that) {
case _Country() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String isoCode,  String nameEs,  String capitalEs,  String continent,  int difficulty,  String flagAssetPath)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Country() when $default != null:
return $default(_that.id,_that.isoCode,_that.nameEs,_that.capitalEs,_that.continent,_that.difficulty,_that.flagAssetPath);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String isoCode,  String nameEs,  String capitalEs,  String continent,  int difficulty,  String flagAssetPath)  $default,) {final _that = this;
switch (_that) {
case _Country():
return $default(_that.id,_that.isoCode,_that.nameEs,_that.capitalEs,_that.continent,_that.difficulty,_that.flagAssetPath);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String isoCode,  String nameEs,  String capitalEs,  String continent,  int difficulty,  String flagAssetPath)?  $default,) {final _that = this;
switch (_that) {
case _Country() when $default != null:
return $default(_that.id,_that.isoCode,_that.nameEs,_that.capitalEs,_that.continent,_that.difficulty,_that.flagAssetPath);case _:
  return null;

}
}

}

/// @nodoc


class _Country implements Country {
  const _Country({required this.id, required this.isoCode, required this.nameEs, required this.capitalEs, required this.continent, required this.difficulty, required this.flagAssetPath});


@override final  int id;
@override final  String isoCode;
@override final  String nameEs;
@override final  String capitalEs;
@override final  String continent;
@override final  int difficulty;
@override final  String flagAssetPath;

/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CountryCopyWith<_Country> get copyWith => __$CountryCopyWithImpl<_Country>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Country&&(identical(other.id, id) || other.id == id)&&(identical(other.isoCode, isoCode) || other.isoCode == isoCode)&&(identical(other.nameEs, nameEs) || other.nameEs == nameEs)&&(identical(other.capitalEs, capitalEs) || other.capitalEs == capitalEs)&&(identical(other.continent, continent) || other.continent == continent)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.flagAssetPath, flagAssetPath) || other.flagAssetPath == flagAssetPath));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,isoCode,nameEs,capitalEs,continent,difficulty,flagAssetPath);
}

@override
String toString() {
    return 'Country(id: $id, isoCode: $isoCode, nameEs: $nameEs, capitalEs: $capitalEs, continent: $continent, difficulty: $difficulty, flagAssetPath: $flagAssetPath)';
}


}

/// @nodoc
abstract mixin class _$CountryCopyWith<$Res> implements $CountryCopyWith<$Res> {
  factory _$CountryCopyWith(_Country value, $Res Function(_Country) _then) = __$CountryCopyWithImpl;
@override @useResult
$Res call({
 int id, String isoCode, String nameEs, String capitalEs, String continent, int difficulty, String flagAssetPath
});




}
/// @nodoc
class __$CountryCopyWithImpl<$Res>
    implements _$CountryCopyWith<$Res> {
  __$CountryCopyWithImpl(this._self, this._then);

  final _Country _self;
  final $Res Function(_Country) _then;

/// Create a copy of Country
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isoCode = null,Object? nameEs = null,Object? capitalEs = null,Object? continent = null,Object? difficulty = null,Object? flagAssetPath = null,}) {
  return _then(_Country(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isoCode: null == isoCode ? _self.isoCode : isoCode // ignore: cast_nullable_to_non_nullable
as String,nameEs: null == nameEs ? _self.nameEs : nameEs // ignore: cast_nullable_to_non_nullable
as String,capitalEs: null == capitalEs ? _self.capitalEs : capitalEs // ignore: cast_nullable_to_non_nullable
as String,continent: null == continent ? _self.continent : continent // ignore: cast_nullable_to_non_nullable
as String,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as int,flagAssetPath: null == flagAssetPath ? _self.flagAssetPath : flagAssetPath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
