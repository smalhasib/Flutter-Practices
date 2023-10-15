// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'taken_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TakenPhoto {
  String get path => throw _privateConstructorUsedError;
  Offset get containerPosition => throw _privateConstructorUsedError;
  Size get containerSize => throw _privateConstructorUsedError;
  Size get imagePreviewSize => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TakenPhotoCopyWith<TakenPhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TakenPhotoCopyWith<$Res> {
  factory $TakenPhotoCopyWith(
          TakenPhoto value, $Res Function(TakenPhoto) then) =
      _$TakenPhotoCopyWithImpl<$Res, TakenPhoto>;
  @useResult
  $Res call(
      {String path,
      Offset containerPosition,
      Size containerSize,
      Size imagePreviewSize});
}

/// @nodoc
class _$TakenPhotoCopyWithImpl<$Res, $Val extends TakenPhoto>
    implements $TakenPhotoCopyWith<$Res> {
  _$TakenPhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? containerPosition = null,
    Object? containerSize = null,
    Object? imagePreviewSize = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      containerPosition: null == containerPosition
          ? _value.containerPosition
          : containerPosition // ignore: cast_nullable_to_non_nullable
              as Offset,
      containerSize: null == containerSize
          ? _value.containerSize
          : containerSize // ignore: cast_nullable_to_non_nullable
              as Size,
      imagePreviewSize: null == imagePreviewSize
          ? _value.imagePreviewSize
          : imagePreviewSize // ignore: cast_nullable_to_non_nullable
              as Size,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TakenPhotoImplCopyWith<$Res>
    implements $TakenPhotoCopyWith<$Res> {
  factory _$$TakenPhotoImplCopyWith(
          _$TakenPhotoImpl value, $Res Function(_$TakenPhotoImpl) then) =
      __$$TakenPhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String path,
      Offset containerPosition,
      Size containerSize,
      Size imagePreviewSize});
}

/// @nodoc
class __$$TakenPhotoImplCopyWithImpl<$Res>
    extends _$TakenPhotoCopyWithImpl<$Res, _$TakenPhotoImpl>
    implements _$$TakenPhotoImplCopyWith<$Res> {
  __$$TakenPhotoImplCopyWithImpl(
      _$TakenPhotoImpl _value, $Res Function(_$TakenPhotoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? containerPosition = null,
    Object? containerSize = null,
    Object? imagePreviewSize = null,
  }) {
    return _then(_$TakenPhotoImpl(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      containerPosition: null == containerPosition
          ? _value.containerPosition
          : containerPosition // ignore: cast_nullable_to_non_nullable
              as Offset,
      containerSize: null == containerSize
          ? _value.containerSize
          : containerSize // ignore: cast_nullable_to_non_nullable
              as Size,
      imagePreviewSize: null == imagePreviewSize
          ? _value.imagePreviewSize
          : imagePreviewSize // ignore: cast_nullable_to_non_nullable
              as Size,
    ));
  }
}

/// @nodoc

class _$TakenPhotoImpl implements _TakenPhoto {
  const _$TakenPhotoImpl(
      {required this.path,
      required this.containerPosition,
      required this.containerSize,
      required this.imagePreviewSize});

  @override
  final String path;
  @override
  final Offset containerPosition;
  @override
  final Size containerSize;
  @override
  final Size imagePreviewSize;

  @override
  String toString() {
    return 'TakenPhoto(path: $path, containerPosition: $containerPosition, containerSize: $containerSize, imagePreviewSize: $imagePreviewSize)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TakenPhotoImpl &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.containerPosition, containerPosition) ||
                other.containerPosition == containerPosition) &&
            (identical(other.containerSize, containerSize) ||
                other.containerSize == containerSize) &&
            (identical(other.imagePreviewSize, imagePreviewSize) ||
                other.imagePreviewSize == imagePreviewSize));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, path, containerPosition, containerSize, imagePreviewSize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TakenPhotoImplCopyWith<_$TakenPhotoImpl> get copyWith =>
      __$$TakenPhotoImplCopyWithImpl<_$TakenPhotoImpl>(this, _$identity);
}

abstract class _TakenPhoto implements TakenPhoto {
  const factory _TakenPhoto(
      {required final String path,
      required final Offset containerPosition,
      required final Size containerSize,
      required final Size imagePreviewSize}) = _$TakenPhotoImpl;

  @override
  String get path;
  @override
  Offset get containerPosition;
  @override
  Size get containerSize;
  @override
  Size get imagePreviewSize;
  @override
  @JsonKey(ignore: true)
  _$$TakenPhotoImplCopyWith<_$TakenPhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
