import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/button_rounded.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool secureText = true;
  var email = null;
  var password = null;

  @override
  void initState() {
    super.initState();
  }

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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            margin: EdgeInsets.only(top: 30, bottom: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "images/pauseplay.png",
                                  height: 150,
                                ),
                                SizedBox(height: 20),
                                InputFieldRounded(
                                  title: "Username",
                                  hint: "Enter User Name",
                                  onChange: (val) {
                                    email = val;
                                  },
                                  icon: Icon(Icons.email),
                                ),
                                SizedBox(height: 10),
                                InputFieldRounded(
                                  title: "Password",
                                  hint: "Password",
                                  suffixIcon: InkWell(
                                    onTap: () {
                                      setState(() {

                                        secureText = !secureText;
                                      });
                                    },
                                    child: Icon(
                                    secureText?  Icons.remove_red_eye_outlined :Icons.visibility_off,
                                      color: ColorPalette.generalPrimaryColor,
                                    ),
                                  ),
                                  onChange: (val) {
                                    password = val;
                                  },
                                  icon: Icon(Icons.lock),
                                  secureText: secureText,
                                ),
                                ButtonRounded(
                                  text: "Login",
                                  onPressed: () {
                                    doLogin(context, email, password);
                                  },
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
                                TextButton(
                                  onPressed: () => Get.toNamed(Routes.register),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: ColorPalette.generalDarkGrey,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Get.toNamed(Routes.forgotPassword),
                                  child: Text(
                                    "Forgot Password?",
                                    style: TextStyle(
                                      color: ColorPalette.generalDarkGrey,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Image.asset(
                                  "images/surety1.png",
                                  height: 60,
                                ),
                              ],
                            ),
                          ),
                        )
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

  doLogin(BuildContext context, String email, String password) async {
    EasyLoading.show(status: 'loading...');
    var result =
        await Provider.of<AuthProvider>(context, listen: false).doSignIn(
      email: email,
      password: password,
    );
    result.fold((l) {
      EasyLoading.dismiss();
      print("===>${l}");
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error Login",
        desc: "Incorrect email or password",
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
