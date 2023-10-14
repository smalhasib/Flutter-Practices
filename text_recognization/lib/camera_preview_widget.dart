import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CameraPreviewWidget extends HookConsumerWidget {
  final Size screenSize;
  final CameraController controller;
  final GlobalKey cropContainerKey;

  const CameraPreviewWidget({
    required this.screenSize,
    required this.controller,
    required this.cropContainerKey,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropBoxBottomPadding = (screenSize.height - screenSize.width) / 2;

    final cropContainerWidth = useState<double>(screenSize.width - 40);
    final cropContainerHeight = useState<double>(120);

    return CameraPreview(
      controller,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: cropBoxBottomPadding),
                child: Container(
                  key: cropContainerKey,
                  width: cropContainerWidth.value,
                  height: cropContainerHeight.value,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            onPanUpdate: (value) {
              final newWidth = cropContainerWidth.value + value.delta.dx;
              final newHeight = cropContainerHeight.value + value.delta.dy;
              if ((newWidth > 50 && newWidth < screenSize.width) &&
                  (newHeight > 50 && newHeight < screenSize.width)) {
                cropContainerWidth.value = newWidth;
                cropContainerHeight.value = newHeight;
              }
            },
            onTapDown: (details) {
              final offset = Offset(
                details.localPosition.dx / constraints.maxWidth,
                details.localPosition.dy / constraints.maxHeight,
              );
              controller.setExposurePoint(offset);
              controller.setFocusPoint(offset);
            },
          );
        },
      ),
    );
  }
}
