import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_recognization/text_detector_painter.dart';

class MainScreen extends HookConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = useState<File?>(null);
    final path = useState<String?>(null);

    final outputText = useState<String?>(null);
    final canProcess = useState<bool>(true);
    final isBusy = useState<bool>(false);
    final customPaint = useState<CustomPaint?>(null);

    final textRecognizer = useMemoized<TextRecognizer>(
      () => TextRecognizer(script: TextRecognitionScript.latin),
    );

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
      path = path;
      final inputImage = InputImage.fromFilePath(path);
      processImage(inputImage);
    }

    Future getImage() async {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        processFile(pickedFile.path);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Text Recognizer'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            image.value != null
                ? SizedBox(
                    height: 400,
                    width: 400,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.file(image.value!),
                      ],
                    ),
                  )
                : const Icon(
                    Icons.image,
                    size: 200,
                  ),
            const SizedBox(height: 8),
            if (image.value != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(path.value == null ? '' : 'Image path: ${path.value}'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => getImage(),
        tooltip: 'Increment',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
