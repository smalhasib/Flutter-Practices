// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_manager.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AppManager {
  List<CameraDescription> get cameras => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AppManagerCopyWith<AppManager> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppManagerCopyWith<$Res> {
  factory $AppManagerCopyWith(
          AppManager value, $Res Function(AppManager) then) =
      _$AppManagerCopyWithImpl<$Res, AppManager>;
  @useResult
  $Res call({List<CameraDescription> cameras});
}

/// @nodoc
class _$AppManagerCopyWithImpl<$Res, $Val extends AppManager>
    implements $AppManagerCopyWith<$Res> {
  _$AppManagerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameras = null,
  }) {
    return _then(_value.copyWith(
      cameras: null == cameras
          ? _value.cameras
          : cameras // ignore: cast_nullable_to_non_nullable
              as List<CameraDescription>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppManagerImplCopyWith<$Res>
    implements $AppManagerCopyWith<$Res> {
  factory _$$AppManagerImplCopyWith(
          _$AppManagerImpl value, $Res Function(_$AppManagerImpl) then) =
      __$$AppManagerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<CameraDescription> cameras});
}

/// @nodoc
class __$$AppManagerImplCopyWithImpl<$Res>
    extends _$AppManagerCopyWithImpl<$Res, _$AppManagerImpl>
    implements _$$AppManagerImplCopyWith<$Res> {
  __$$AppManagerImplCopyWithImpl(
      _$AppManagerImpl _value, $Res Function(_$AppManagerImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cameras = null,
  }) {
    return _then(_$AppManagerImpl(
      cameras: null == cameras
          ? _value._cameras
          : cameras // ignore: cast_nullable_to_non_nullable
              as List<CameraDescription>,
    ));
  }
}

/// @nodoc

class _$AppManagerImpl implements _AppManager {
  const _$AppManagerImpl({required final List<CameraDescription> cameras})
      : _cameras = cameras;

  final List<CameraDescription> _cameras;
  @override
  List<CameraDescription> get cameras {
    if (_cameras is EqualUnmodifiableListView) return _cameras;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cameras);
  }

  @override
  String toString() {
    return 'AppManager(cameras: $cameras)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppManagerImpl &&
            const DeepCollectionEquality().equals(other._cameras, _cameras));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_cameras));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AppManagerImplCopyWith<_$AppManagerImpl> get copyWith =>
      __$$AppManagerImplCopyWithImpl<_$AppManagerImpl>(this, _$identity);
}

abstract class _AppManager implements AppManager {
  const factory _AppManager({required final List<CameraDescription> cameras}) =
      _$AppManagerImpl;

  @override
  List<CameraDescription> get cameras;
  @override
  @JsonKey(ignore: true)
  _$$AppManagerImplCopyWith<_$AppManagerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
