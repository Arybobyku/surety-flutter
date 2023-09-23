import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/model/diary_model.dart';
import 'package:surety/provider/diary_provider.dart';
import 'package:surety/ui/widget/button_rounded.dart';

import '../../widget/input_field_rounded.dart';

class UserDiaryEditPage extends StatefulWidget {
  const UserDiaryEditPage({Key? key}) : super(key: key);

  @override
  State<UserDiaryEditPage> createState() => _UserDiaryEditPageState();
}

class _UserDiaryEditPageState extends State<UserDiaryEditPage> {
  DiaryModel diaryModel = Get.arguments['diary'];
  DiaryProvider diaryProvider = Get.arguments['provider'];
  File? photoProfile = null;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: diaryProvider),
      ],
      child: Scaffold(
        backgroundColor: ColorPalette.generalBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  diaryModel.image != null && photoProfile == null
                      ? CachedNetworkImage(
                    imageUrl: diaryModel.image ?? "",
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

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Icon(Icons.lock, size: 20),
                      SizedBox(
                        height: 20,
                        child: Switch(
                          value: diaryModel.isPublic ?? false,
                          onChanged: (val) {
                            setState(() {
                              diaryModel.isPublic = val;
                            });
                          },
                        ),
                      ),
                      Icon(Icons.public, size: 20),
                    ],
                  ),
                  SizedBox(height: 10),
                  InputFieldRounded(
                    title: "Description",
                    hint: "Description",
                    initialValue: diaryModel.description,
                    onChange: (val) {
                      diaryModel.description = val;
                    },
                  ),
                  SizedBox(height: 10),
                  ButtonRounded(
                    text: "Update",
                    onPressed: () async {
                      await diaryProvider.updateDiary(
                          photoProfile, diaryModel);

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Success Update Article")));
                    },
                  ),
                ],
              ),
            ),
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
}
