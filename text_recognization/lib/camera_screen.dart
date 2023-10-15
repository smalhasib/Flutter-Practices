import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:text_recognization/app_manager.dart';
import 'package:text_recognization/camera_preview_widget.dart';
import 'package:text_recognization/custom_dialog.dart';
import 'package:text_recognization/taken_photo.dart';

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

    Size getContainerSize(GlobalKey key) {
      final RenderBox containerRenderBox = key.currentContext?.findRenderObject() as RenderBox;
      final containerSize = containerRenderBox.size;
      return containerSize;
    }

    Offset getContainerPosition(GlobalKey key) {
      final RenderBox containerRenderBox = key.currentContext?.findRenderObject() as RenderBox;
      final containerPosition = containerRenderBox.localToGlobal(Offset.zero);
      return containerPosition;
    }

    Offset getCropPositionAccordingToCameraPreview() {
      final containerPosition = getContainerPosition(_cropContainerKey);

      final RenderBox parentRenderBox =
          _cameraPreviewKey.currentContext?.findRenderObject() as RenderBox;
      return parentRenderBox.globalToLocal(containerPosition);
    }

    void loadAndReadText() {
      showLoadingDialog(context);

      final position = getCropPositionAccordingToCameraPreview();
      final containerSize = getContainerSize(_cropContainerKey);
      final imagePreviewSize = getContainerSize(_cameraPreviewKey);

      controller.takePicture().then((file) {
        final data = TakenPhoto(
          path: file.path,
          containerPosition: position,
          containerSize: containerSize,
          imagePreviewSize: imagePreviewSize,
        );
        Navigator.of(context).pop();
        context.router.pop(data);
      });
    }

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
                          onPressed: loadAndReadText,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                          ),
                          child: const Text('Take Picture'),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: Theme.of(context).colorScheme.background,
                          child: const Text(
                            'Drag the box to RESIZE and fit One or Multiple Lines of Numbers of your ticket.',
                            style: TextStyle(fontSize: 17, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
        },
      ),
    );
  }
}
