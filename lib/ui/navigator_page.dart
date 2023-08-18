import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/constants.dart';
import 'package:surety/local_storage_service.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/routes.dart';
import 'package:surety/setup_locator.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class NavigatorPage extends StatefulWidget {
  const NavigatorPage({Key? key}) : super(key: key);

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  @override
  Widget build(BuildContext context) {
    navigated(context);
    return Scaffold(
      backgroundColor: ColorPalette.generalBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/pauseplay.png',
              width: 100,
            ),
          ],
        ),
      ),
    );
  }

  navigated(BuildContext context) async {
    var storageService = locator<LocalStorageService>();
    var role = storageService.getIntFromPref(Constants.role);
    String? userJson = storageService.getStringFromPref(Constants.userModel);

    var user = await FirebaseAuth.instance.currentUser??null;

    await Future.delayed(const Duration(seconds: 2), () async {
      if (user==null) {
        Get.offAllNamed(Routes.login);
      } else if(role==1){
        UserModel userModel = UserModel.fromJson(jsonDecode(userJson!), user.uid);
        Provider.of<AuthProvider>(context,listen: false).setUserModelFromPref(userModel);
        Get.offAllNamed(Routes.adminDashboard);
      }else{
        UserModel? userModel = UserModel.fromJson(jsonDecode(userJson!), user.uid);
        Provider.of<AuthProvider>(context,listen: false).setUserModelFromPref(userModel);
        Get.offAllNamed(Routes.mainMenu);
      }
    });
  }
}
