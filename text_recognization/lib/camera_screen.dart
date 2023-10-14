import 'package:auto_route/annotations.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:text_recognization/app_manager.dart';
import 'package:text_recognization/camera_preview_widget.dart';

@RoutePage()
class CameraScreen extends HookConsumerWidget {
  CameraScreen({super.key});

  final GlobalKey _cropContainerKey = GlobalKey(debugLabel: 'CropContainerKey');
  final GlobalKey _cameraPreviewKey = GlobalKey(debugLabel: 'CameraPreviewKey');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size screenSize = MediaQuery.of(context).size;
    final AppManager appManager = ref.watch(appManagerNotifierProvider);

    CameraController onNewCameraSelected() {
      return CameraController(
        appManager.cameras.first,
        ResolutionPreset.high,
      );
    }

    final controller = useMemoized<CameraController>(onNewCameraSelected);
    late final Future<void> cameraInitializationFuture;

    useEffect(() {
      cameraInitializationFuture = controller.initialize();

      return null;
    }, const []);

    useOnAppLifecycleStateChange((previous, current) {
      // App state changed before we got the chance to initialize.
      if (controller.value.isInitialized) {
        return;
      }
      if (current == AppLifecycleState.inactive) {
        controller.dispose();
      } else if (current == AppLifecycleState.resumed) {
        onNewCameraSelected();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Screen'),
      ),
      body: FutureBuilder<void>(
        future: cameraInitializationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                  key: _cameraPreviewKey,
                  child: CameraPreviewWidget(
                    controller: controller,
                    screenSize: screenSize,
                    cropContainerKey: _cropContainerKey,
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('Take Picture'),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Center(child: Text(snapshot.error.toString()));
          }
        },
      ),
    );
  }
}
