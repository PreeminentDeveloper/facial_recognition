import 'package:flutter/material.dart';

import '../helpers/utils.dart';

typedef SaveCallBack = void Function(String? value);
typedef ValidateCallBack = String? Function(String? value);

class CustomInputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final int? maxLength;
  final TextEditingController? controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final bool obscureText, readOnly;
  final dynamic onSave;
  final dynamic onChanged;
  final dynamic inputFormatters;
  final dynamic validator;
  const CustomInputField({
    Key? key,
    required this.hintText,
    this.labelText,
    this.maxLength,
    required this.textInputAction,
    required this.keyboardType,
    this.suffixIcon,
    this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.inputFormatters,
    this.onSave,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height(context) * 0.110,
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        key: key,
        onChanged: onChanged,
        onSaved: onSave,
        validator: validator,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        obscureText: obscureText,
        cursorColor: Colors.black,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            // floatingLabelBehavior: FloatingLabelBehavior.auto,
            // labelText: hintText,
            // labelStyle:
            //     textTheme(context).caption?.copyWith(color: Colors.black),
            // suffixIcon: suffixIcon ?? Container(),
            // prefixIcon: Icon(Icons.email),
            contentPadding: const EdgeInsets.only(
              left: 15.0,
              top: 35.0,
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: BorderSide(
                    color: colorScheme(context).secondary, width: 2)),
            hintText: hintText,
            labelText: labelText,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide:
                  BorderSide(color: colorScheme(context).secondary, width: 2),
            ),

            // errorText: "faliure",
            hintStyle:
                textTheme(context).subtitle1?.copyWith(color: Colors.grey)),
      ),
    );
  }
}
