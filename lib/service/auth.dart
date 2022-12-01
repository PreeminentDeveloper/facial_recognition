import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static signInWithEmail(
      {required String email, required String password}) async {
    try {
      final response = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final User? user = response.user;
      return {'success': true, 'message': user};
    } on FirebaseAuthException catch (e) {
      // return e.message;
      return {'success': false, 'message': e.message};
    }
  }

  static signUpWithEmail(
      {required String email, required String password}) async {
    try {
      final response = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final User? user = response.user;
      return {'success': true, 'message': user};
    } on FirebaseAuthException catch (e) {
      // return e.message;
      return {'success': false, 'message': e.message};
    }
  }

  static logout() async {
    await _auth.signOut();
  }
}

class UserManagement {
  static storeNewUser({fullName, email, password, role, uid}) async {
    final docUser = FirebaseFirestore.instance.collection("users").doc(uid);
    final newUser = {
      'full_name': fullName,
      'email': email,
      "password": password,
      "role": role
    };
    await docUser.set(newUser);
  }

  static readUser() async {
    final docUser = FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}

class UserHelper {
  static FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future saveStudentData(
      {String? photoUrl,
      String? lastName,
      String? firstName,
      String? matricNumber,
      String? department,
      String? level,
      String? accademicSession,
      String? semester,
      String? courseName,
      String? courseCode}) async {
    Map<String, dynamic> studentData = {
      "photo_url": photoUrl,
      "last_name": lastName,
      "first_name": firstName,
      "matric_number": matricNumber,
      "department": department,
      "level": level,
      "accademicSession": accademicSession,
      "semester": semester,
      "course_name": courseName,
      "course_code": courseCode,
    };

    final userRef = _db.collection("students").doc();
    await userRef.set(studentData);
  }
}
