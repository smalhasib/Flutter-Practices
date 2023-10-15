import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img_pkg;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:text_recognization/app_manager.dart';
import 'package:text_recognization/app_router.dart';
import 'package:text_recognization/taken_photo.dart';
import 'package:text_recognization/text_detector_painter.dart';

@RoutePage()
class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = useState<File?>(null);

    final outputText = useState<String?>(null);
    final canProcess = useState<bool>(true);
    final isBusy = useState<bool>(false);
    final customPaint = useState<CustomPaint?>(null);

    final textRecognizer = useMemoized<TextRecognizer>(
      () => TextRecognizer(script: TextRecognitionScript.latin),
    );

    useEffect(() {
      ref.read(appManagerNotifierProvider.notifier).init();

      return null;
    }, const []);

    Future<void> processImage(InputImage inputImage) async {
      if (!canProcess.value) return;
      if (isBusy.value) return;
      isBusy.value = true;
      outputText.value = '';

      final recognizedText = await textRecognizer.processImage(inputImage);
      if (inputImage.metadata?.size != null && inputImage.metadata?.rotation != null) {
        final painter = TextRecognizerPainter(
          recognizedText,
          inputImage.metadata!.size,
          inputImage.metadata!.rotation,
          CameraLensDirection.back,
        );
        customPaint.value = CustomPaint(painter: painter);
      } else {
        outputText.value = 'Recognized text:\n\n${recognizedText.text}';
        // TODO: set _customPaint to draw boundingRect on top of image
        customPaint.value = null;
      }
      isBusy.value = false;
    }

    Future processFile(String path) async {
      image.value = File(path);
      final inputImage = InputImage.fromFilePath(path);
      processImage(inputImage);
    }

    Future getImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        processFile(pickedFile.path);
      }
    }

    Size getCompatibleCropSize(
        img_pkg.Image originalImage, Size imagePreviewSize, Size containerSize) {
      final imageWidth = originalImage.width;
      final imageHeight = originalImage.height;
      if (imageWidth > imageHeight) {
        final widthFactor = imageHeight / imagePreviewSize.width;
        final heightFactor = imageWidth / imagePreviewSize.height;
        return Size(containerSize.width * widthFactor, containerSize.height * heightFactor);
      } else {
        final widthFactor = imageWidth / imagePreviewSize.width;
        final heightFactor = imageHeight / imagePreviewSize.height;
        return Size(containerSize.width * widthFactor, containerSize.height * heightFactor);
      }
    }

    Offset getCompatibleCropPosition(
        img_pkg.Image originalImage, Size imagePreviewSize, Offset containerPosition) {
      final imageWidth = originalImage.width;
      final imageHeight = originalImage.height;
      if (imageWidth > imageHeight) {
        final widthFactor = imageHeight / imagePreviewSize.width;
        final heightFactor = imageWidth / imagePreviewSize.height;
        return Offset(widthFactor * containerPosition.dx, heightFactor * containerPosition.dy);
      } else {
        final widthFactor = imageWidth / imagePreviewSize.width;
        final heightFactor = imageHeight / imagePreviewSize.height;
        return Offset(widthFactor * containerPosition.dx, heightFactor * containerPosition.dy);
      }
    }

    Future<String> cropImage(TakenPhoto takenPhoto) async {
      final img = img_pkg.decodeJpg(File(takenPhoto.path).readAsBytesSync());
      final originalImage = img_pkg.bakeOrientation(img!);

      final cropSize = getCompatibleCropSize(
        originalImage,
        takenPhoto.imagePreviewSize,
        takenPhoto.containerSize,
      );
      final cropPosition = getCompatibleCropPosition(
        originalImage,
        takenPhoto.imagePreviewSize,
        takenPhoto.containerPosition,
      );

      final croppedImage = img_pkg.copyCrop(
        originalImage,
        x: cropPosition.dx.toInt(),
        y: cropPosition.dy.toInt(),
        width: cropSize.width.toInt(),
        height: cropSize.height.toInt(),
      );

      final directory = await getApplicationCacheDirectory();
      final path = join(directory.path, '${DateTime.now()}.png');
      final file = await File(path).create(recursive: true);
      file.writeAsBytesSync(img_pkg.encodePng(croppedImage));
      return path;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Text Recognizer'),
      ),
      body: image.value == null
          ? Center(
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'No image selected',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Image.file(image.value!),
                    ),
                    const SizedBox(height: 8),
                    if (outputText.value != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(outputText.value!),
                      ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final takenPhoto = (await context.router.push(CameraRoute())) as TakenPhoto;
          final path = await cropImage(takenPhoto);
          processFile(path);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
