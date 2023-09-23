import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/model/banner_model.dart';
import 'package:surety/provider/admin.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/banner_provider.dart';
import 'package:surety/provider/form_provider.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/button_rounded.dart';
import 'package:surety/ui/widget/horizontal_icon_label.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';

class AdminInfoPage extends StatefulWidget {
  const AdminInfoPage({Key? key}) : super(key: key);

  @override
  State<AdminInfoPage> createState() => _AdminInfoPageState();
}

class _AdminInfoPageState extends State<AdminInfoPage> {
  bool getData = true;
  int selectedIndex = Get.arguments ?? 0;
  File? photoProfile = null;

  @override
  void initState() {
    if (getData) {
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
                          size: 60,
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
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
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
                  icon: Icons.psychology,
                  label: "Experts",
                  ontap: () => Get.toNamed(Routes.adminExperts),
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
          child: Consumer<BannerProvider>(builder: (context, state, _) {
            BannerModel? banner = state.banner;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorPalette.generalBannerColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: 150,
                    child: Row(
                      children: [
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: state.banner?.image ?? "",
                            imageBuilder: (context, imageProvider) => Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image,
                              size: 150,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  banner?.text ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(
                                  height: 10,
                                ),
                                InkWell(
                                  onTap: ()=>Get.toNamed(Routes.webView,arguments: banner!.url!),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                                    decoration: BoxDecoration(
                                        color:
                                            ColorPalette.generalMarronColor,
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                    ),
                                    child: Text(
                                      banner?.buttonText ?? "",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  state.banner?.image != null && photoProfile == null
                      ? CachedNetworkImage(
                          imageUrl: state.banner?.image ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.image,
                            size: 150,
                          ),
                        )
                      : photoProfile != null
                          ? SizedBox(
                              height: 150,
                              child: Stack(
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 15, bottom: 30),
                                    height: double.infinity,
                                    width: 150,
                                    decoration: BoxDecoration(
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
                              ),
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
                    title: "Url",
                    hint: "Url",
                    minLines: 5,
                    initialValue: banner?.url,
                    onChange: (val) {
                      banner?.url = val;
                    },
                  ),
                  InputFieldRounded(
                    title: "Text",
                    hint: "Text",
                    minLines: 5,
                    initialValue: banner?.text,
                    onChange: (val) {
                      banner?.text = val;
                    },
                  ),
                  InputFieldRounded(
                    title: "Button Text",
                    hint: "Button Text",
                    initialValue: banner?.text,
                    onChange: (val) {
                      banner?.buttonText = val;
                    },
                  ),
                  ButtonRounded(
                    text: "Update Banner",
                    onPressed: () async {
                      await context
                          .read<BannerProvider>()
                          .updateBanner(photoProfile, banner!);

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Success update banner")));
                    },
                  ),
                ],
              ),
            );
          }),
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
    }, (r) async {
      await context.read<FormProvider>().resetForm();
      EasyLoading.dismiss();
      Get.offAllNamed(Routes.login);
    });
  }
}
