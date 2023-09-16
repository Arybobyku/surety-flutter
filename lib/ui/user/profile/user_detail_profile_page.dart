import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:surety/ui/widget/button_picker.dart';
import 'package:surety/ui/widget/button_rounded.dart';
import 'package:surety/ui/widget/dropdown_container.dart';

import '../../widget/input_field_rounded.dart';

class UserDetailProfilePage extends StatefulWidget {
  const UserDetailProfilePage({Key? key}) : super(key: key);

  @override
  State<UserDetailProfilePage> createState() => _UserDetailProfilePageState();
}

class _UserDetailProfilePageState extends State<UserDetailProfilePage> {
  File? photoProfile = null;

  bool secureText = true;
  bool secureText2 = true;

  String? password = null;
  String? password2 = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<AuthProvider>(
          builder: (context,state,_) {
            return Text(state.user.fullName ?? "Profile");
          }
        ),
        backgroundColor: ColorPalette.generalSecondaryColor,
        actions: [
          TextButton(
            onPressed: () => doLogout(context),
            child: Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      backgroundColor: ColorPalette.generalBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<AuthProvider>(
            builder: (context, valueAuth, _) {
              return Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    valueAuth.user.photoProfile != null
                        ? CachedNetworkImage(
                            imageUrl: valueAuth.user.photoProfile ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.person,
                              size: 150,
                            ),
                          )
                        : photoProfile != null
                            ? Stack(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 15, bottom: 30),
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: FileImage(photoProfile!),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    height: 150,
                                    alignment: Alignment.bottomCenter,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          photoProfile = null;
                                        });
                                      },
                                      child:
                                          Icon(Icons.delete, color: Colors.red),
                                    ),
                                  )
                                ],
                              )
                            : Icon(
                                Icons.person,
                                size: 150,
                              ),

                    photoProfile == null
                        ? InkWell(
                            onTap: () => doImagePicker(),
                            child: Icon(Icons.edit),
                          )
                        : SizedBox(),
                    InputFieldRounded(
                      hint: "Full Name",
                      initialValue: valueAuth.user.fullName,
                      icon: Icon(Icons.person),
                      onChange: (val) {
                        valueAuth.user.fullName = val;
                      },
                    ),
                    InputFieldRounded(
                      hint: "Email",
                      icon: Icon(Icons.email),
                      initialValue: valueAuth.user.email,
                      enable: false,
                      onChange: (val) {
                        valueAuth.user.email = val;
                      },
                      secureText: false,
                    ),
                    InputFieldRounded(
                      hint: "Bio",
                      initialValue: valueAuth.user.bio,
                      minLines: 5,
                      onChange: (val) {
                        valueAuth.user.bio = val;
                      },
                    ),
                    SizedBox(height: 7),
                    InkWell(
                      onTap: () {
                        DatePicker.showDatePicker(
                          context,
                          onChanged: (val) {},
                          onConfirm: (val) {
                            setState(() {
                              valueAuth.user.dateOfBirth =
                                  "${val.day}/${val.month}/${val.year}";
                            });
                          },
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10),
                            Text(
                              valueAuth.user.dateOfBirth != null
                                  ? "${valueAuth.user.dateOfBirth}"
                                  : "Date of Birth",
                              style: TextStyle(
                                color: valueAuth.user.dateOfBirth != null
                                    ? Colors.black
                                    : Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 7),
                    DropdownContainer(
                      value: valueAuth.user.gender,
                      onChanged: (val) {
                        setState(() {
                          valueAuth.user.gender = val;
                        });
                      },
                      items: ["Male", "Female"],
                      hint: 'Gender',
                      icon: Icon(Icons.man, color: Colors.grey),
                    ),

                    ButtonRounded(
                      text: "Save",
                      onPressed: () => doSave(valueAuth.user, photoProfile),
                    ),

                    SizedBox(height: 20),

                    InputFieldRounded(
                      hint: "New Password",
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
                      hint: "Confirm New Password",
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

                    ButtonRounded(
                      text: "Change Password",
                      onPressed: () => doChangePassword(password,password2),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  doImagePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      setState(() {
        photoProfile = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  doSave(UserModel userModel, File? photo) async {
    EasyLoading.show(status: "Loading...");
    var result = await Provider.of<AuthProvider>(context, listen: false)
        .doUpdateProfile(userModel, photo);
    result.fold((l) {
      EasyLoading.dismiss();
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error Update Profile",
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
    });
  }

  doChangePassword(String? password1, String? password2) async {
    if(password1 == null){
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please insert password")));
    }
    if(password1 != password2){
      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password do not match")));
    }
    EasyLoading.show(status: "Loading...");

    var result = await Provider.of<AuthProvider>(context, listen: false)
        .doChangePassword(password1!);

    result.fold((l) {
      EasyLoading.dismiss();
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error Change Password",
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

      return ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Success change passwrod")));
    });
  }

  doLogout(BuildContext context) async {
    EasyLoading.show(status: "Loading...");
    var result =
        await Provider.of<AuthProvider>(context, listen: false).doSignOut();
    result.fold((l) {
      EasyLoading.dismiss();
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error Logout",
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
      Get.offAllNamed(Routes.login);
    });
  }
}
