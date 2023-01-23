import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unblurition',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _storedImage;

  Future<void> _takePicture() async {
    final takenImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    if (takenImage != null) {
      final imageFile = File(takenImage.path);
      final appDir = await syspaths.getApplicationDocumentsDirectory();
      final filename = path.basename(imageFile.path);
      final savedImage = await imageFile.copy('${appDir.path}/$filename');
      setState(() {
        _storedImage = savedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unblurition'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              alignment: Alignment.center,
              child: _storedImage != null
                  ? Image.file(
                _storedImage!,
                fit: BoxFit.cover,
                width: double.infinity,
              )
                  : const Text(
                'No image Taken',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  child: const Icon(Icons.add_photo_alternate),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Process'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
