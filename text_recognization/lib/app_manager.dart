import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_manager.freezed.dart';
part 'app_manager.g.dart';

@freezed
class AppManager with _$AppManager {
  const factory AppManager({
    required List<CameraDescription> cameras,
  }) = _AppManager;
}

@Riverpod(keepAlive: true)
class AppManagerNotifier extends _$AppManagerNotifier {
  @override
  AppManager build() {
    return const AppManager(
      cameras: [],
    );
  }

  void init() async {
    state = state.copyWith(cameras: await availableCameras());
  }
}