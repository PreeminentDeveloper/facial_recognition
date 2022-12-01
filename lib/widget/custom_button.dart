import 'package:flutter/material.dart';

import '../helpers/utils.dart';

typedef ButtonCallback = void Function();

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    required this.primaryColor,
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final ButtonCallback? onPressed;
  final String text;
  final primaryColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // backgroundColor: Theme.of(context).colorScheme.secondary,
        primary: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        textStyle: Theme.of(context).textTheme.button,
        elevation: 10,
        shadowColor: const Color(0xFFFFE0E8),
        maximumSize: Size(width(context), 59),
        minimumSize: Size(width(context), 59),
      ),
      child: Text(text,
          style: textTheme(context)
              .subtitle1
              ?.copyWith(color: colorScheme(context).onSecondary)),
    );
  }
}
