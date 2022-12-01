import 'dart:io';

import 'package:facial_recognition/screens/Home/student_record.dart';
import 'package:facial_recognition/helpers/utils.dart';
import 'package:facial_recognition/screens/Home/welcome.dart';
import 'package:facial_recognition/screens/face_detection/face_page.dart';
import 'package:facial_recognition/widget/build_drawer.dart';
import 'package:facial_recognition/widget/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import '../../service/auth.dart';

class ScanStudent extends StatefulWidget {
  const ScanStudent({Key? key}) : super(key: key);

  @override
  State<ScanStudent> createState() => _ScanStudentState();
}

class _ScanStudentState extends State<ScanStudent> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  File? pickedImage;
  bool _load = false;
  ImagePicker? imagePicker;
  final ImagePicker _picker = ImagePicker();

  var imageFile;
  File? _imageFile;

  List<Rect> rect = <Rect>[];

  bool isFaceDetected = false;

  Future pickImage() async {
    // var awaitImage = await imagePicker?.pickImage(source: ImageSource.gallery);

    // imageFile = await awaitImage?.readAsBytes();
    // imageFile = await decodeImageFromList(imageFile);

    // setState(() {
    //   imageFile = imageFile;
    //   pickedImage = awaitImage as File?;
    // });

    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        // show snackbar
        ScaffoldMessenger.of(context)
            .showSnackBar(new SnackBar(content: new Text("No image selected")));
        _imageFile = null;
      }
      Navigator.pop(context);
    });

    File checkFile(pickedFileData) {
      File checkedFile;
      File file = File(pickedFileData.path);
      if (pickedFileData != null) {
        checkedFile = file;
      } else {
        checkedFile = null as File;
      }
      return checkedFile;
    }

    FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(checkFile(pickedFile));

    final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();

    final List<Face> faces = await faceDetector.processImage(visionImage);
    if (rect.length > 0) {
      rect = <Rect>[];
    }

    for (Face face in faces) {
      rect.add(face.boundingBox);

      final double? rotY =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double? rotZ =
          face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
      print('the rotation y is ' + rotY!.toStringAsFixed(2));
      print('the rotation z is ' + rotZ!.toStringAsFixed(2));
    }

    setState(() {
      isFaceDetected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Scan Student",
            style: textTheme(context).headline5!.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: AppColours.blue,
        ),
        key: scaffoldKey,
        drawer: BuildDrawer(
          role: "Invigilator",
          item: "Scan Student",
          color: AppColours.blue,
          icon: Icons.person_search_rounded,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  const SizedBox(height: 50.0),
                  isFaceDetected
                      ? Center(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(blurRadius: 20),
                              ],
                            ),
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                            child: FittedBox(
                              child: SizedBox(
                                width: imageFile.width.toDouble(),
                                height: imageFile.height.toDouble(),
                                child: CustomPaint(
                                  painter: FacePainter(
                                      rect: rect, imageFile: imageFile),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Center(
                    child: TextButton.icon(
                      icon: const Icon(
                        Icons.photo_camera,
                        size: 100,
                      ),
                      label: const Text(''),
                      // textColor: Theme.of(context).primaryColor,
                      onPressed: () async {
                        pickImage();
                      },
                    ),
                  ),
                ],
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    child: CustomButton(
                        text: "Scan",
                        primaryColor: AppColours.blue,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FacePage()))),
                  )),
            ],
          ),
        ));
  }
}

class FacePainter extends CustomPainter {
  List<Rect> rect;
  var imageFile;

  FacePainter({required this.rect, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }

    for (Rect rectangle in rect) {
      canvas.drawRect(
        rectangle,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
