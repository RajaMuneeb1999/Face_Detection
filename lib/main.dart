import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File? _image;
  List<Face>? _faces;

  Future _getImage() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _image = File(imageFile!.path);
    });
  }

  Future _detectFaces() async {
    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(_image);
    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
    final List<Face> faces = await faceDetector.processImage(visionImage);
    setState(() {
      _faces = faces;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Face Detector'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _image == null ? Text('No image selected.') : Image.file(_image!),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _getImage,
                child: Text('Select Image'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _detectFaces,
                child: Text('Detect Faces'),
              ),
              SizedBox(height: 16.0),
              _faces == null
                  ? Text('')
                  : Text('${_faces!.length} face(s) detected.'),
            ],
          ),
        ),
      ),
    );
  }
}
