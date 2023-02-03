import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as syspaths;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReconLab',
      debugShowCheckedModeBanner: false,
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
  Uint8List? _base64;
  bool _isProcessing = false;
  Future? _processed;

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
        _isProcessing = false;
      });

      var stream = http.ByteStream(imageFile.openRead())..cast();
      // get file length
      var length = await imageFile.length(); //imageFile is your image file
      Map<String, String> headers = {
        "Content-type": "multipart/form-data",
      }; // ignore this headers if there is no authentication

      // string to uri
      var uri = Uri.parse("http://10.0.2.2:5000/api/upload/multiple");

      // create multipart request
      var request = http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFileSign = http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFileSign);

      //add headers
      request.headers.addAll(headers);

      // send
      var response = await request.send();

      print(response.statusCode);

      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  Future<void> _imageReconstruct() async {
    final uri = Uri.parse("http://10.0.2.2:5000/api/reconstract");
    final response = await http.get(uri);
    final Map<String, dynamic>? data = json.decode(response.body);
    if (data == null) return;
    print(data['status']);
    setState(() {
      _base64 = const Base64Decoder()
          .convert((data['status'] as String).split('\'')[1]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ReconLab'),
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
              child: _isProcessing == false
                  ? _storedImage != null
                      ? Image.file(
                          _storedImage!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        )
                      : const Text(
                          'No image Taken',
                          textAlign: TextAlign.center,
                        )
                  : FutureBuilder(
                      future: _processed,
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : snapshot.error != null
                                  ? const Center(
                                      child: Icon(Icons.error),
                                    )
                                  : _base64 != null
                                      ? Image.memory(
                                          _base64!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : const Text(
                                          'No image Taken',
                                          textAlign: TextAlign.center,
                                        ),
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
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.add_photo_alternate),
                        Text("Choose"),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _processed = _imageReconstruct();
                    setState(() {
                      _isProcessing = true;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.wifi_protected_setup),
                        Text("Process"),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
