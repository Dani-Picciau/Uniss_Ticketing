// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'administrator_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AdministratorResponse _$AdministratorResponseFromJson(
  Map<String, dynamic> json,
) {
  return _AdministratorResponse.fromJson(json);
}

/// @nodoc
mixin _$AdministratorResponse {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get surname => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;

  /// Serializes this AdministratorResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdministratorResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdministratorResponseCopyWith<AdministratorResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdministratorResponseCopyWith<$Res> {
  factory $AdministratorResponseCopyWith(
    AdministratorResponse value,
    $Res Function(AdministratorResponse) then,
  ) = _$AdministratorResponseCopyWithImpl<$Res, AdministratorResponse>;
  @useResult
  $Res call({String id, String name, String surname, String? title});
}

/// @nodoc
class _$AdministratorResponseCopyWithImpl<
  $Res,
  $Val extends AdministratorResponse
>
    implements $AdministratorResponseCopyWith<$Res> {
  _$AdministratorResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdministratorResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? surname = null,
    Object? title = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            surname: null == surname
                ? _value.surname
                : surname // ignore: cast_nullable_to_non_nullable
                      as String,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AdministratorResponseImplCopyWith<$Res>
    implements $AdministratorResponseCopyWith<$Res> {
  factory _$$AdministratorResponseImplCopyWith(
    _$AdministratorResponseImpl value,
    $Res Function(_$AdministratorResponseImpl) then,
  ) = __$$AdministratorResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String surname, String? title});
}

/// @nodoc
class __$$AdministratorResponseImplCopyWithImpl<$Res>
    extends
        _$AdministratorResponseCopyWithImpl<$Res, _$AdministratorResponseImpl>
    implements _$$AdministratorResponseImplCopyWith<$Res> {
  __$$AdministratorResponseImplCopyWithImpl(
    _$AdministratorResponseImpl _value,
    $Res Function(_$AdministratorResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AdministratorResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? surname = null,
    Object? title = freezed,
  }) {
    return _then(
      _$AdministratorResponseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        surname: null == surname
            ? _value.surname
            : surname // ignore: cast_nullable_to_non_nullable
                  as String,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AdministratorResponseImpl implements _AdministratorResponse {
  const _$AdministratorResponseImpl({
    required this.id,
    required this.name,
    required this.surname,
    this.title,
  });

  factory _$AdministratorResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdministratorResponseImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String surname;
  @override
  final String? title;

  @override
  String toString() {
    return 'AdministratorResponse(id: $id, name: $name, surname: $surname, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdministratorResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.surname, surname) || other.surname == surname) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, surname, title);

  /// Create a copy of AdministratorResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdministratorResponseImplCopyWith<_$AdministratorResponseImpl>
  get copyWith =>
      __$$AdministratorResponseImplCopyWithImpl<_$AdministratorResponseImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AdministratorResponseImplToJson(this);
  }
}

abstract class _AdministratorResponse implements AdministratorResponse {
  const factory _AdministratorResponse({
    required final String id,
    required final String name,
    required final String surname,
    final String? title,
  }) = _$AdministratorResponseImpl;

  factory _AdministratorResponse.fromJson(Map<String, dynamic> json) =
      _$AdministratorResponseImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get surname;
  @override
  String? get title;

  /// Create a copy of AdministratorResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdministratorResponseImplCopyWith<_$AdministratorResponseImpl>
  get copyWith => throw _privateConstructorUsedError;
}
