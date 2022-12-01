import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FacePage extends StatefulWidget {
  const FacePage({Key? key}) : super(key: key);

  @override
  State<FacePage> createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  File? _imageFile;
  List<Face>? _faces;
  final ImagePicker _picker = ImagePicker();

  void _getImageAndDetectFaces() async {
    final imageFile = await _picker.pickImage(source: ImageSource.gallery);
    final image = FirebaseVisionImage.fromFile(imageFile as File);
    final faceDetector = FirebaseVision.instance.faceDetector();
    final faces = await faceDetector.processImage(image);
    setState(() {
      if (mounted) {
        _imageFile = imageFile as File;
        _faces = faces;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ImageAndFaces(
        imageFile: _imageFile,
        faces: _faces,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getImageAndDetectFaces,
        tooltip: "Pick an image",
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

class ImageAndFaces extends StatelessWidget {
  const ImageAndFaces({Key? key, this.faces, required this.imageFile})
      : super(key: key);

  final List<Face>? faces;
  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
            flex: 2,
            child: Container(
              constraints: const BoxConstraints.expand(),
              child: Image.file(
                imageFile!,
                fit: BoxFit.cover,
              ),
            )),
        Flexible(
            flex: 1,
            child: ListView(
              children: faces!.map<Widget>((f) => FaceCoordinates(f)).toList(),
            ))
      ],
    );
  }
}

class FaceCoordinates extends StatelessWidget {
  const FaceCoordinates(this.face, {Key? key}) : super(key: key);
  final Face face;

  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    return ListTile(
      title: Text('(${pos.top}, (${pos.bottom}), (${pos.right})'),
    );
  }
}
