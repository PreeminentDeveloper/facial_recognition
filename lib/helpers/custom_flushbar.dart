import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CustomFlushBar {
  showErrorFlushBar({required title, required body, required context}) {
    Flushbar(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      borderRadius: BorderRadius.circular(6),
      title: "$title",
      titleColor: Colors.white,
      message: "$body",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.red,
      boxShadows: [
        BoxShadow(
            color: Colors.red[700] as Color,
            offset: const Offset(0.0, 2.0),
            blurRadius: 1.0)
      ],
      backgroundGradient: LinearGradient(
          colors: [Colors.red[500] as Color, Colors.red[700] as Color]),
      isDismissible: true,
      duration: const Duration(seconds: 10),
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      mainButton: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          "Close",
          style: TextStyle(color: Colors.white),
        ),
      ),
      showProgressIndicator: false,
      progressIndicatorBackgroundColor: Colors.black,
    ).show(context);
  }

  showSuccessFlushBar({required title, required body, required context}) {
    Flushbar(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      borderRadius: BorderRadius.circular(6),
      title: "$title",
      titleColor: Colors.white,
      message: "$body",
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      backgroundColor: Colors.green,
      boxShadows: [
        BoxShadow(
            color: Colors.green[700] as Color,
            offset: const Offset(0.0, 2.0),
            blurRadius: 1.0)
      ],
      backgroundGradient: LinearGradient(
          colors: [Colors.green[500] as Color, Colors.green[700] as Color]),
      isDismissible: true,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.check,
        color: Colors.white,
      ),
      mainButton: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          "Close",
          style: TextStyle(color: Colors.white),
        ),
      ),
      showProgressIndicator: false,
      // progressIndicatorBackgroundColor: Colors.black,
    ).show(context);
  }
}
