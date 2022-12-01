import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:facial_recognition/helpers/validators.dart';
import 'package:facial_recognition/service/auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../helpers/custom_flushbar.dart';
import 'package:flutter/material.dart';

import '../../../helpers/utils.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_input_field.dart';
import '../../widget/loader.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final CustomFlushBar customFlushBar = CustomFlushBar();

  bool isAdmin = true;
  bool onSignIn = true;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Validators validators = Validators();

  String _fullName = "";
  String _emailEntry = "";
  String _passwordEntry = "";

  submit(context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    dynamic response;
    try {
      setState(() => isLoading = true);
      if (onSignIn) {
        response = await AuthProvider.signInWithEmail(
            email: _emailEntry, password: _passwordEntry);

        print("RESPONSE: $response");
        var success = response["success"];
        if (success == false) {
          // show flushbar
          customFlushBar.showErrorFlushBar(
              title: 'Error', body: "${response['message']}", context: context);
        } else {
          // show flushbar
          customFlushBar.showSuccessFlushBar(
              title: 'Success', body: "Login Successful", context: context);
        }
        setState(() => isLoading = false);
      } else {
        print("Email $_emailEntry Password $_passwordEntry");
        response = await AuthProvider.signUpWithEmail(
            email: _emailEntry, password: _passwordEntry);

        print("Signup RESPONSE: $response");
        var success = response["success"];
        if (success == false) {
          // show flushbar
          customFlushBar.showErrorFlushBar(
              title: 'Error', body: "${response['message']}", context: context);
        } else {
          String uid = response['message'].uid;
          String role = isAdmin ? "admin" : "invigilator";
          await UserManagement.storeNewUser(
              fullName: _fullName,
              email: _emailEntry,
              password: _passwordEntry,
              role: role,
              uid: uid);

          // show flushbar
          customFlushBar.showSuccessFlushBar(
              title: 'Success', body: "Signup Successful", context: context);
        }
        setState(() => isLoading = false);
      }
    } catch (e) {
      // show flushbar
      customFlushBar.showErrorFlushBar(
          title: 'Error occured', body: '$e', context: context);
    }
  }

  toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    setState(() {});
  }

  toggleObscureConfirmPassword() {
    obscureConfirmPassword = !obscureConfirmPassword;
    setState(() {});
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildren(rebuild);
  }

  String checkAccountStatus(bool onSignInCheck, bool isAdminCheck) {
    if (isAdmin) {
      if (onSignInCheck) {
        return "Not an Admin yet?";
      }
    } else {
      if (onSignInCheck) {
        return "Not an Invigilator yet?";
      }
    }
    return "Already have an account?";
  }

  String checkAccountAction(bool onSignInCheck, bool isAdminCheck) {
    if (isAdmin) {
      if (onSignInCheck) {
        return " Sign Up";
      }
    } else {
      if (onSignInCheck) {
        return " Sign Up";
      }
    }
    return " Sign In";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator:
            Loader(isAdmin == true ? AppColours.green : AppColours.blue),
        child: Center(
          child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 50),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            isAdmin ? "Admin" : "Invigilator",
                            style: textTheme(context).headline5,
                          ),
                        ),
                      ),
                      Visibility(
                        visible: onSignIn ? false : true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                "Full Name",
                                style: textTheme(context).subtitle2,
                              ),
                            ),
                            CustomInputField(
                                hintText: "Full Name",
                                validator: (String? value) =>
                                    validators.validateName(value),
                                onSave: (dynamic value) {
                                  setState(() {
                                    _fullName = value;
                                    print("Full Name entry: $_fullName");
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.name),
                            const SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Email Address",
                          style: textTheme(context).subtitle2,
                        ),
                      ),
                      CustomInputField(
                          hintText: "Email",
                          validator: (String? value) =>
                              validators.validateEmail(value),
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(
                                RegExp(r"\s\b|\b\s"))
                          ],
                          onSave: (dynamic value) {
                            setState(() {
                              _emailEntry = value;
                              print("Email entry: $_emailEntry");
                            });
                          },
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Password",
                          style: textTheme(context).subtitle2,
                        ),
                      ),
                      CustomInputField(
                          hintText: "Password",
                          suffixIcon: GestureDetector(
                              onTap: () {
                                toggleObscurePassword();
                                rebuildAllChildren(context);
                              },
                              child: Icon(
                                obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: isAdmin
                                    ? AppColours.green
                                    : AppColours.blue,
                              )),
                          validator: (String? value) =>
                              validators.validatePassword(value),
                          onSave: (dynamic value) {
                            setState(() {
                              _passwordEntry = value;
                              print("Password entry: $_passwordEntry");
                            });
                          },
                          onChanged: (dynamic value) {
                            setState(() {
                              _passwordEntry = value;
                              print("Password entry: $_passwordEntry");
                            });
                          },
                          textInputAction: TextInputAction.next,
                          obscureText: obscurePassword,
                          keyboardType: TextInputType.visiblePassword),
                      const SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: onSignIn ? false : true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Confirm Password",
                                style: textTheme(context).subtitle2,
                              ),
                            ),
                            CustomInputField(
                                hintText: "Confirm Password",
                                suffixIcon: GestureDetector(
                                    onTap: () {
                                      toggleObscureConfirmPassword();
                                      rebuildAllChildren(context);
                                    },
                                    child: Icon(
                                      obscureConfirmPassword
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: isAdmin
                                          ? const Color.fromARGB(
                                              255, 10, 109, 63)
                                          : const Color.fromARGB(
                                              255, 46, 68, 143),
                                    )),
                                validator: (String? value) =>
                                    validators.validateConfirmPassword(
                                        value: value,
                                        passwordEntry: _passwordEntry),

                                // (String? value) {
                                //   if (value!.trim().isEmpty) {
                                //     return 'Confirm Password cannot be empty';
                                //   } else if (value.toString().length < 8) {
                                //     return 'Confirm Password must not be less than 8 characters';
                                //   } else if (value != _passwordEntry) {
                                //     return "Password Mismatch";
                                //   }
                                // },
                                onSave: (dynamic value) {
                                  setState(() {
                                    print(
                                        "Confirm Password entry: $_passwordEntry");
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                obscureText: obscureConfirmPassword,
                                keyboardType: TextInputType.visiblePassword),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: CustomButton(
                            text: onSignIn ? "Sign In" : "Sign Up",
                            primaryColor:
                                isAdmin ? AppColours.green : AppColours.blue,
                            onPressed: () {
                              submit(context);
                            }),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  if (isAdmin) {
                                    setState(() {
                                      isAdmin = false;
                                      onSignIn = true;
                                    });
                                  } else {
                                    setState(() {
                                      isAdmin = true;
                                      onSignIn = true;
                                    });
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: isAdmin
                                        ? 'Are you an Invigilator?'
                                        : 'Are you an Admin?',
                                    style: textTheme(context)
                                        .subtitle1
                                        ?.copyWith(),
                                    children: [
                                      TextSpan(
                                          text: " Sign In",
                                          style: textTheme(context)
                                              .subtitle1
                                              ?.copyWith(
                                                color: isAdmin
                                                    ? const Color.fromARGB(
                                                        255, 10, 109, 63)
                                                    : const Color.fromARGB(
                                                        255, 46, 68, 143),
                                              ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Text("Or"),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  if (onSignIn) {
                                    setState(() {
                                      onSignIn = false;
                                    });
                                  } else {
                                    setState(() {
                                      onSignIn = true;
                                    });
                                  }
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: checkAccountStatus(onSignIn, isAdmin),
                                    style: textTheme(context)
                                        .subtitle1
                                        ?.copyWith(),
                                    children: [
                                      TextSpan(
                                          text: checkAccountAction(
                                              onSignIn, isAdmin),
                                          style: textTheme(context)
                                              .subtitle1
                                              ?.copyWith(
                                                color: isAdmin
                                                    ? const Color.fromARGB(
                                                        255, 10, 109, 63)
                                                    : const Color.fromARGB(
                                                        255, 46, 68, 143),
                                              ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
