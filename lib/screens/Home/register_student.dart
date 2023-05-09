import 'dart:io';

import 'package:facial_recognition/service/auth.dart';
import 'package:facial_recognition/widget/custom_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/custom_flushbar.dart';

import '../../helpers/utils.dart';
import '../../widget/build_drawer.dart';
import '../../widget/custom_input_field.dart';
import '../../widget/loader.dart';

class RegisterStudent extends StatefulWidget {
  const RegisterStudent({Key? key}) : super(key: key);

  @override
  State<RegisterStudent> createState() => _RegisterStudentState();
}

class _RegisterStudentState extends State<RegisterStudent> {
  // late BuildContext scaffoldContext;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final CustomFlushBar customFlushBar = CustomFlushBar();
  File? _imageFile;
  String _fileName = "";
  String urlDownload = "";
  UploadTask? uploadTask;
  PlatformFile? pickedFile;
  final ImagePicker _picker = ImagePicker();
  bool isLoading = false;

  submit(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      setState(() => isLoading = true);
      await uploadFile();
      if (_imageFile != null && urlDownload.isNotEmpty) {
        print("URL Download Link: $urlDownload");
        dynamic response = await UserHelper.saveStudentData(
            photoUrl: urlDownload,
            lastName: _lastNameController.text,
            firstName: _firstNameController.text,
            matricNumber: _matricNumberController.text,
            department: _departmentController.text,
            level: _levelController.text,
            accademicSession: _accademicSessionController.text,
            semester: _semesterController.text,
            courseName: _courseNameControler.text,
            courseCode: _courseCodeController.text);
        setState(() {
          clearAllFields();
          isLoading = false;
        });
        print("Enrollment response: $response");
        print("Student Enrolled Successfully");
        customFlushBar.showSuccessFlushBar(
            title: 'Success',
            body: "Student Enrolled Successfully",
            context: context);
      } else {
        // show flushbar
        customFlushBar.showErrorFlushBar(
            title: 'Error occured', body: 'No Photo taken.', context: context);
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      // show flushbar
      customFlushBar.showErrorFlushBar(
          title: 'Error occured', body: '$e', context: context);
    }
  }

  clearAllFields() {
    _imageFile = null;
    _lastNameController.clear();
    _firstNameController.clear();
    _matricNumberController.clear();
    _departmentController.clear();
    _levelController.clear();
    _accademicSessionController.clear();
    _semesterController.clear();
    _courseNameControler.clear();
    _courseCodeController.clear();
  }

  Widget bottomSheet() {
    return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            const Text("Choose Profile photo",
                style: TextStyle(fontSize: 20.0)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      takePhoto(ImageSource.camera);
                      // selectFile();
                    },
                    icon: const Icon(Icons.camera_alt, color: AppColours.green),
                    label: const Text(
                      "Camera",
                      style: TextStyle(color: AppColours.green),
                    )),
                TextButton.icon(
                    onPressed: () {
                      takePhoto(ImageSource.gallery);
                      // selectFile();
                    },
                    icon: const Icon(
                      Icons.image,
                      color: AppColours.green,
                    ),
                    label: const Text(
                      "Gallery",
                      style: TextStyle(color: AppColours.green),
                    ))
              ],
            )
          ],
        ));
  }

  // void takePhoto(ImageSource source) async {
  //   final XFile? pickedFile = await _picker.pickImage(source: source);
  //   File imageFile = File(pickedFile!.path);
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //   String appDocPath = appDocDir.path;
  //   // print("Image File picked: ${_imageFile!.path}");
  //   final fileName = Path.basename(imageFile.path);
  //   final File localImage = await imageFile.copy('$appDocPath/$fileName');
  //   print("Local Image: $localImage");
  //   String fileName2 = localImage.path.split('/').last;

  //   print("File Name 2: $fileName2");
  //   // print("File name: $fileName");
  //   setState(() {
  //     _imageFile = pickedFile as PickedFile?;

  //     Navigator.pop(context);
  //   });
  // }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
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
  }

  Future uploadFile() async {
    _fileName = _imageFile!.path.split('/').last;
    // if (_imageFile == null) return;
    // final fileName = Path.basename(_imageFile!.path);
    // final destination = 'files/$fileName';
    final path = 'images/$_fileName';
    final imagePath = File(_imageFile!.path);

    print("PATH: $path");
    print("IMAGE PATH: $imagePath");

    try {
      // upload image to firestore
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(_imageFile!);

      // get the download link of the image
      final snapshot = await uploadTask!.whenComplete(() {});
      urlDownload = await snapshot.ref.getDownloadURL();
      print("Download Link: $urlDownload");
    } catch (e) {
      print('error occured: $e');
    }
  }

  // Future selectFile() async {
  //   final result = await FilePicker.platform.pickFiles();
  //   if (result == null) return;

  //   setState(() {
  //     pickedFile = result.files.first;
  //     print("Picked File: $pickedFile");
  //     Navigator.pop(context);
  //   });
  // }

  Widget imageProfile() {
    return Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 80.0,
          backgroundImage: _imageFile == null
              // pickedFile == null
              ? const AssetImage("assets/avatar.jpg")
              : FileImage(File(_imageFile!.path)) as ImageProvider,
          //           : FileImage(File(pickedFile!.path!)) as ImageProvider,
        ),
        Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => bottomSheet()));
              },
              child: const Icon(Icons.camera_alt,
                  color: AppColours.green, size: 28.0),
            ))
      ],
    );
  }

  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _matricNumberController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();
  final TextEditingController _accademicSessionController =
      TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _courseNameControler = TextEditingController();
  final TextEditingController _courseCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Register Student",
            style: textTheme(context).headline5!.copyWith(color: Colors.white),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: AppColours.green,
        ),
        key: scaffoldKey,
        drawer: BuildDrawer(
          role: "Admin",
          item: "Student Enrollment",
          color: AppColours.green,
          icon: Icons.person,
        ),
        body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: isLoading,
            progressIndicator: Loader(AppColours.green),
            child: Stack(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: imageProfile(),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Last Name",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "Last Name",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Last Name cannot be empty';
                                        }
                                      },
                                      controller: _lastNameController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "First Name",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "First Name",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'First Name cannot be empty';
                                        }
                                      },
                                      controller: _firstNameController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Matric Number",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "Matric Number",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Matric Number cannot be empty';
                                        }
                                      },
                                      controller: _matricNumberController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Department",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "Department",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Department cannot be empty';
                                        }
                                      },
                                      controller: _departmentController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Level",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "Level",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Level cannot be empty';
                                        }
                                      },
                                      controller: _levelController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Accademic Session",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "Accademic Session",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Accademic Session cannot be empty';
                                        }
                                      },
                                      controller: _accademicSessionController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Semester",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "Semester",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Semester cannot be empty';
                                        }
                                      },
                                      controller: _semesterController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Course Name",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "Course Name",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Course Name cannot be empty';
                                        }
                                      },
                                      controller: _courseNameControler,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.name),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    child: Text(
                                      "Course Code",
                                      style: textTheme(context).subtitle2,
                                    ),
                                  ),
                                  CustomInputField(
                                      hintText: "Course Code",
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Course Code cannot be empty';
                                        }
                                      },
                                      controller: _courseCodeController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.text),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: CustomButton(
                                        text: "Submit",
                                        primaryColor: AppColours.green,
                                        onPressed: () {
                                          submit(context);
                                        }),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}
