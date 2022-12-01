import 'package:flutter/material.dart';

/// height of the screen
double height(BuildContext context) => MediaQuery.of(context).size.height;
double width(BuildContext context) => MediaQuery.of(context).size.width;

// custom colors
class AppColours {
  static const Color green = Color.fromARGB(255, 10, 109, 63);

  static const Color blue = Color.fromARGB(255, 46, 68, 143);
}

ColorScheme colorScheme(BuildContext context) => Theme.of(context).colorScheme;
TextTheme textTheme(BuildContext context) => Theme.of(context).textTheme;
/// color scheme


