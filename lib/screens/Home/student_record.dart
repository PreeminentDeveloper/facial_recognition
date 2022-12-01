import 'package:facial_recognition/helpers/utils.dart';
import 'package:flutter/material.dart';

class StudentRecord extends StatelessWidget {
  const StudentRecord({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student Record",
          style: textTheme(context).headline5,
        ),
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  width: 130,
                  height: 130,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/avatar.jpg"),
                          fit: BoxFit.cover))),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: Rhamon Raji",
                  style: textTheme(context).subtitle2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Matric Number: F/HD/19/2422",
                  style: textTheme(context).subtitle2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Department: Computer Science",
                  style: textTheme(context).subtitle2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Level: HND 2",
                  style: textTheme(context).subtitle2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Accademic Session: Second Semester",
                  style: textTheme(context).subtitle2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Semester: Second",
                  style: textTheme(context).subtitle2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Course Title: Java 2",
                  style: textTheme(context).subtitle2,
                ),
                const SizedBox(height: 20),
                Text(
                  "Course Code: Com 332",
                  style: textTheme(context).subtitle2,
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
