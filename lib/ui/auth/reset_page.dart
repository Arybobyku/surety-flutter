import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';

import '../widget/button_rounded.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  String? email = null;

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
                width: double.infinity,
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
                        Image.asset(
                          "images/pauseplay.png",
                          height: 150,
                        ),
                        SizedBox(height: 20),
                        InputFieldRounded(
                          title: "Reset Password",
                          hint: "Enter your email",
                          onChange: (val) {
                            email = val;
                          },
                          icon: Icon(Icons.email),
                        ),
                        ButtonRounded(
                          text: "Send Verification",
                          onPressed: () => resetPassword(email!),
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

  resetPassword(String email) async {
    var result = await Provider.of<AuthProvider>(context, listen: false)
        .doResetPassword(email);

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
    }, (r) async {
      EasyLoading.dismiss();

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Success send verification to your email")));

      await Future.delayed(Duration(seconds: 3));
      Get.back();
    });
  }
}
