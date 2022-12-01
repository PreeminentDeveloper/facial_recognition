// @dart=2.9
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:facial_recognition/screens/Home/scan_student.dart';
import 'package:facial_recognition/screens/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'screens/Home/register_student.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  final storage = const FlutterSecureStorage();

  saveDate(key, value) async {
    await storage.write(key: key, value: value);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Face Recognition',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: StreamBuilder<User>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                // if (snapshot.connectionState == ConnectionState.waiting) {
                //   return Loader(Color.fromARGB(255, 10, 109, 63));
                // }
                if (snapshot.hasData && snapshot.data != null) {
                  dynamic signedInUser = snapshot.data;
                  String uid = signedInUser.uid;
                  return StreamBuilder<Map<String, dynamic>>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .snapshots()
                          .map((query) => query.data()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print("SPANPSHOT: ${snapshot.data}");
                          final role = snapshot.data['role'];
                          if (role == "admin") {
                            return const RegisterStudent();
                          } else {
                            return const ScanStudent();
                          }
                        }
                        return const SignIn();
                      });
                }
                return const SignIn();
              })),
    );
  }
}
