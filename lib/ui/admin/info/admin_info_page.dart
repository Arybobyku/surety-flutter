import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/admin.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/horizontal_icon_label.dart';

class AdminInfoPage extends StatefulWidget {
  const AdminInfoPage({Key? key}) : super(key: key);

  @override
  State<AdminInfoPage> createState() => _AdminInfoPageState();
}

class _AdminInfoPageState extends State<AdminInfoPage> {
  bool getData = true;
  int selectedIndex = Get.arguments ?? 0;

  @override
  void initState() {
    if (getData) {
      // EasyLoading.show(status: "Loading");
      Provider.of<AdminProvider>(context, listen: false).getAllUser();
      getData = false;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Consumer<AuthProvider>(builder: (context, state, _) {
          return Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: ColorPalette.generalPrimaryColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: state.user.photoProfile ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                            width: 60.0,
                            height: 60.0,
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
                            size: 80,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          state.user.fullName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          state.user.email,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                      ],
                    )),
                HorizontalIconLabel(
                  icon: Icons.add,
                  label: "Add Article",
                  ontap: () => Get.toNamed(Routes.adminArticles),
                ),
                HorizontalIconLabel(
                  icon: Icons.add,
                  label: "Add Products",
                  ontap: () => Get.toNamed(Routes.adminProducts),
                ),
                HorizontalIconLabel(
                  icon: Icons.app_shortcut,
                  label: "Surety Apps",
                  ontap: () => Get.toNamed(Routes.mainMenu),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 1,
                  color: ColorPalette.generalGrey,
                ),
                HorizontalIconLabel(
                  icon: Icons.logout,
                  label: "Logout",
                  color: Colors.red,
                  ontap: () {
                    doSignOut(context);
                  },
                ),
              ],
            ),
          );
        }),
        appBar: AppBar(
          title: Text(
            "Admin Dashboard",
            style: TextStyle(color: ColorPalette.generalPrimaryColor),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }

  doSignOut(BuildContext context) async {
    EasyLoading.show(status: "Loading...");
    var result =
        await Provider.of<AuthProvider>(context, listen: false).doSignOut();
    result.fold((l) {
      EasyLoading.dismiss();
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
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
