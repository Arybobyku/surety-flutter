import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/button_rounded.dart';

import '../widget/dropdown_container.dart';
import '../widget/input_field_rounded.dart';

class RegisterExpertisePage extends StatefulWidget {
  const RegisterExpertisePage({Key? key}) : super(key: key);

  @override
  _RegisterExpertisePageState createState() => _RegisterExpertisePageState();
}

class _RegisterExpertisePageState extends State<RegisterExpertisePage> {
  // File? photoProfile = null;
  File? filePicker = null;
  bool secureText = true;
  bool secureText2 = true;
  String? email = null;
  String? password = null;
  String? password2 = null;
  String? fullName = null;
  String? gender = null;
  DateTime? dateOfBirth = null;
  String? expertise = null;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPalette.generalSecondaryColor,
        body: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorPalette.generalBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Image.asset(
                          "images/pauseplay.png",
                          height: 150,
                        ),
                        SizedBox(height: 20),
                        // photoProfile != null
                        //     ? Container(
                        //         margin: EdgeInsets.only(top: 15, bottom: 30),
                        //         height: 200,
                        //         width: 150,
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(5),
                        //           image: DecorationImage(
                        //             fit: BoxFit.cover,
                        //             image: FileImage(photoProfile!),
                        //           ),
                        //         ),
                        //       )
                        //     : ButtonPicker(
                        //         title: "Photo Profile",
                        //         onTap: () => doImagePicker(),
                        //       ),
                        Text(
                          "Create Professional Account",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        InputFieldRounded(
                          hint: "Full Name",
                          icon: Icon(Icons.person),
                          onChange: (val) {
                            fullName = val;
                          },
                          secureText: false,
                        ),
                        InputFieldRounded(
                          hint: "Email",
                          icon: Icon(Icons.email),
                          onChange: (val) {
                            email = val;
                          },
                          secureText: false,
                        ),
                        SizedBox(height: 7),
                        InkWell(
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              onChanged: (val) {},
                              onConfirm: (val) {
                                setState(() {
                                  dateOfBirth = val;
                                });
                              },
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  dateOfBirth != null
                                      ? "${dateOfBirth?.day}/${dateOfBirth?.month}/${dateOfBirth?.year}"
                                      : "Date of Birth",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 7),
                        DropdownContainer(
                          value: gender,
                          onChanged: (val) {
                            setState(() {
                              gender = val;
                            });
                          },
                          items: ["Male", "Female"],
                          hint: 'Gender',
                          icon: Icon(Icons.man, color: Colors.grey),
                        ),
                        InputFieldRounded(
                          hint: "Password",
                          icon: Icon(Icons.lock),
                          onChange: (val) {
                            password = val;
                          },
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                secureText = !secureText;
                              });
                            },
                            child: Icon(
                              secureText?  Icons.visibility_off :Icons.visibility,
                              color: ColorPalette.generalPrimaryColor,
                            ),
                          ),
                          secureText: secureText,
                        ),
                        InputFieldRounded(
                          hint: "Confirm Password",
                          icon: Icon(Icons.lock),
                          onChange: (val) {
                            password2 = val;
                          },
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                secureText2 = !secureText2;
                              });
                            },
                            child: Icon(
                              secureText2?  Icons.visibility_off :Icons.visibility,
                              color: ColorPalette.generalPrimaryColor,
                            ),
                          ),
                          secureText: secureText2,
                        ),
                        InputFieldRounded(
                          hint: "Expertise",
                          onChange: (val) {
                            expertise = val;
                          },
                          secureText: false,
                        ),
                        ButtonRounded(
                          text: "Create Account",
                          onPressed: () {
                            doRegister(
                              context: context,
                              namaLengkap: fullName,
                              email: email,
                              password: password,
                              dateOfBirth:
                                  "${dateOfBirth?.day}/${dateOfBirth?.month}/${dateOfBirth?.year}",
                              gender: gender,
                              expertise: expertise,
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () =>
                              Get.offNamedUntil(Routes.login, (route) => false),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Already have an account ? ",
                                  style: TextStyle(
                                    color: ColorPalette.generalDarkGrey,
                                  ),
                                ),
                                Text(
                                  "Login",
                                  style: TextStyle(
                                    color: ColorPalette.generalPrimaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: ColorPalette.generalDarkGrey,
                                height: 4,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Or Sign in With",
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorPalette.generalDarkGrey,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Divider(
                                color: ColorPalette.generalDarkGrey,
                                height: 4,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                doSignWithGoogle();
                              },
                              child: Image.asset(
                                'images/google.png',
                                height: 25,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Image.asset(
                          "images/surety1.png",
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  doFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
      ],
    );

    if (result != null) {
      setState(() {
        filePicker = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  // doImagePicker() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['jpg', 'png', 'jpeg'],
  //   );
  //
  //   if (result != null) {
  //     setState(() {
  //       photoProfile = File(result.files.single.path!);
  //     });
  //   } else {
  //     // User canceled the picker
  //   }
  // }

  doRegister({
    required BuildContext context,
    File? photoProfile,
    String? namaLengkap,
    String? email,
    String? password,
    String? dateOfBirth,
    String? gender,
    String? expertise,
  }) async {
    if (namaLengkap != null && email != null && password != null) {
      EasyLoading.show(status: "Loading...");
      UserModel user = UserModel(
        email: email,
        password: password,
        fullName: namaLengkap,
        dateOfBirth: dateOfBirth,
        gender: gender,
        expertise: expertise,
        isValid: false,
      );
      var result = await Provider.of<AuthProvider>(context, listen: false)
          .doSignUp(user: user);

      result.fold((l) {
        EasyLoading.dismiss();
        Alert(
          context: context,
          type: AlertType.error,
          title: "Failed Registration",
          desc: l,
          buttons: [
            DialogButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
              color: ColorPalette.generalPrimaryColor,
              radius: BorderRadius.circular(0.0),
            ),
          ],
        ).show();
      }, (r) {
        EasyLoading.dismiss();
        Get.offNamedUntil(Routes.login, (route) => false);
      });
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Failed Registration",
        desc: "Please fill all the forms",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: ColorPalette.generalPrimaryColor,
            radius: BorderRadius.circular(0.0),
          ),
        ],
      ).show();
    }
  }

  doSignWithGoogle() async {
    var result = await Provider.of<AuthProvider>(context, listen: false)
        .doSignInWithGoogle();

    result.fold((l) {
      EasyLoading.dismiss();
      print("===>${l}");
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Something went wrong",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: ColorPalette.generalPrimaryColor,
            radius: BorderRadius.circular(0.0),
          ),
        ],
      ).show();
    }, (r) {
      EasyLoading.dismiss();
      Get.offAllNamed(
        Routes.navigator,
      );
    });
  }
}
