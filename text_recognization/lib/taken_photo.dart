import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'taken_photo.freezed.dart';

@freezed
class TakenPhoto with _$TakenPhoto {
  const factory TakenPhoto({
    required String path,
    required Offset containerPosition,
    required Size containerSize,
    required Size imagePreviewSize,
  }) = _TakenPhoto;
}
