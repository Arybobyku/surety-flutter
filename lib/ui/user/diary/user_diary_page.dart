import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/helper/extension/string_extension.dart';
import 'package:surety/model/diary_model.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/diary_provider.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/button_rounded.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';
import 'package:surety/ui/widget/video_widget.dart';
import 'package:video_player/video_player.dart';

class UserDiaryPage extends StatefulWidget {
  const UserDiaryPage({Key? key}) : super(key: key);

  @override
  State<UserDiaryPage> createState() => _UserDiaryPageState();
}

class _UserDiaryPageState extends State<UserDiaryPage> {
  File? image = null;
  TextEditingController description = TextEditingController();
  bool isPublic = true;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DiaryProvider()
            ..getAllDiaryByCreator(
              context.read<AuthProvider>().user.id!,
            ),
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorPalette.generalBackgroundColor,
        body: SafeArea(
          child: Consumer<AuthProvider>(builder: (context, authState, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${authState.user.fullName ?? "-"} Diary",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(DateFormat('dd MMMM,yyyy').format(DateTime.now()))
                      ],
                    ),
                  ),
                  Divider(height: 10, color: Colors.black),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "what's on your mind today?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.lock, size: 20),
                                SizedBox(
                                  height: 20,
                                  child: Switch(
                                    value: isPublic,
                                    onChanged: (val) {
                                      setState(() {
                                        isPublic = val;
                                      });
                                    },
                                  ),
                                ),
                                Icon(Icons.public, size: 20),
                              ],
                            ),
                          ],
                        ),
                        InputFieldRounded(
                          hint: '...',
                          controller: description,
                          onChange: (String value) {
                            setState(() {});
                          },
                        ),
                        image == null
                            ? InkWell(
                                onTap: () {
                                  doImagePicker();
                                },
                                child: Icon(Icons.add_a_photo),
                              )
                            : Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        image = null;
                                      });
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                                  SizedBox(width: 10),
                                  image != null &&
                                          image!.path
                                              .getExtension()
                                              .contains("mp4")
                                      ? Expanded(
                                          child: Container(
                                            height: 200,
                                            width: double.infinity,
                                            child: VideoPlayer(
                                              VideoPlayerController.file(
                                                File(image!.path),
                                              )..initialize(),
                                            ),
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              top: 15, bottom: 30),
                                          height: 150,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: FileImage(image!),
                                            ),
                                          ),
                                        ),
                                ],
                              ),

                        if (description.text != "" || image != null)
                          ButtonRounded(
                            text: "Submit",
                            onPressed: () {
                              context.read<DiaryProvider>().createDiary(
                                    DiaryModel(
                                      userModel: authState.user,
                                      description: description.text,
                                      isPublic: isPublic,
                                    ),
                                    image,
                                  );

                              setState(() {
                                description = TextEditingController();
                                image = null;
                              });
                            },
                          ),

                        /// Content
                        Consumer<DiaryProvider>(
                          builder: (context, state, _) {
                            return state.loading
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: state.diariesByCreator.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final diary =
                                          state.diariesByCreator[index];

                                      return Container(
                                        padding: EdgeInsets.all(15),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            /// Header
                                            Row(
                                              children: [
                                                CachedNetworkImage(
                                                  imageUrl: diary.userModel
                                                          ?.photoProfile ??
                                                      "",
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    width: 30.0,
                                                    height: 30.0,
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
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(
                                                    Icons.person,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        diary.userModel
                                                                ?.fullName ??
                                                            "-",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      if (diary.isExpert!)
                                                        Row(
                                                          children: [
                                                            Icon(
                                                                Icons
                                                                    .stars_sharp,
                                                                size: 18),
                                                            Text("Expert"),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    diary.isPublic!
                                                        ? Icon(Icons.public)
                                                        : Icon(Icons.lock),
                                                    Text(
                                                      diary.createdAt!
                                                          .timeAgoFormat(),
                                                      style: TextStyle(
                                                          fontSize: 11),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),

                                            /// Body
                                            Text(
                                              diary.description ?? "",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(height: 5),
                                            diary.image != null
                                                ? diary.image!
                                                        .getExtension()
                                                        .contains("mp4")
                                                    ? VideoWidget(
                                                        url: diary.image!,
                                                        play: true,
                                                        key: new PageStorageKey(
                                                          "keydata$index",
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 180,
                                                        width: double.infinity,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(10),
                                                          ),
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            image: NetworkImage(
                                                                diary.image!),
                                                          ),
                                                        ),
                                                      )
                                                : SizedBox(),
                                            SizedBox(height: 15),
                                            Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    diary.likes!
                                                            .where((element) =>
                                                                element.email ==
                                                                authState
                                                                    .user.email)
                                                            .isNotEmpty
                                                        ? context
                                                            .read<
                                                                DiaryProvider>()
                                                            .unLikeDiary(
                                                              diary,
                                                              authState.user,
                                                              true,
                                                            )
                                                        : context
                                                            .read<
                                                                DiaryProvider>()
                                                            .likeDiary(
                                                              diary,
                                                              authState.user,
                                                              true,
                                                            );
                                                  },
                                                  child: Icon(
                                                    diary.likes != null &&
                                                            diary.likes!
                                                                .where((element) =>
                                                                    element
                                                                        .email ==
                                                                    authState
                                                                        .user
                                                                        .email)
                                                                .isNotEmpty
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: ColorPalette
                                                        .generalPrimaryColor,
                                                  ),
                                                ),
                                                if (diary.likes != null &&
                                                    diary.likes!.isNotEmpty)
                                                  Text(
                                                    "${diary.likes?.length ?? ""}",
                                                    style: TextStyle(
                                                      color: ColorPalette
                                                          .generalPrimaryColor,
                                                    ),
                                                  ),
                                                SizedBox(width: 10),
                                                InkWell(
                                                  child: Icon(
                                                    Icons.comment,
                                                    color: ColorPalette
                                                        .generalPrimaryColor,
                                                  ),
                                                  onTap: () {
                                                    context
                                                        .read<DiaryProvider>()
                                                        .viewDetail(diary);

                                                    Get.toNamed(
                                                      Routes.userCommentPage,
                                                      arguments: context.read<
                                                          DiaryProvider>(),
                                                    );
                                                  },
                                                ),
                                                if (diary.comments != null &&
                                                    diary.comments!.isNotEmpty)
                                                  Text(
                                                    "${diary.comments?.length ?? ""}",
                                                    style: TextStyle(
                                                      color: ColorPalette
                                                          .generalPrimaryColor,
                                                    ),
                                                  ),
                                                Expanded(
                                                    child: SizedBox(
                                                  width: 10,
                                                )),
                                                InkWell(
                                                  onTap: () {
                                                    Get.toNamed(
                                                      Routes.userDiaryEditPage,
                                                      arguments: {
                                                        "diary": diary,
                                                        'provider': context.read<
                                                            DiaryProvider>(),
                                                      },
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.edit,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                InkWell(
                                                  onTap: () {
                                                    Alert(
                                                      context: context,
                                                      type: AlertType.warning,
                                                      title: "Remove",
                                                      desc:
                                                          "Are you sure to remove this post",
                                                      buttons: [
                                                        DialogButton(
                                                          child: Text(
                                                            "Close",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          color: Colors.red,
                                                          radius: BorderRadius
                                                              .circular(0.0),
                                                        ),
                                                        DialogButton(
                                                          child: Text(
                                                            "Remove",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20),
                                                          ),
                                                          onPressed: () {
                                                            context
                                                                .read<
                                                                    DiaryProvider>()
                                                                .removeDiary(
                                                                    diary.id!);

                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          color: Colors.blue,
                                                          radius: BorderRadius
                                                              .circular(0.0),
                                                        ),
                                                      ],
                                                    ).show();
                                                  },
                                                  child: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            if (diary.comments != null &&
                                                diary.comments!.isNotEmpty)
                                              InkWell(
                                                onTap: () {
                                                  context
                                                      .read<DiaryProvider>()
                                                      .viewDetail(diary);

                                                  Get.toNamed(
                                                    Routes.userCommentPage,
                                                    arguments: context
                                                        .read<DiaryProvider>(),
                                                  );
                                                },
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SizedBox(height: 5),
                                                      Divider(),
                                                      Text(
                                                          "Comments ${diary.comments?.length ?? ""}"),
                                                      SizedBox(height: 7),
                                                      Row(
                                                        children: [
                                                          CachedNetworkImage(
                                                            imageUrl: diary
                                                                    .userModel
                                                                    ?.photoProfile ??
                                                                "",
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                Container(
                                                              width: 20.0,
                                                              height: 20.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      imageProvider,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            placeholder: (context,
                                                                    url) =>
                                                                CircularProgressIndicator(),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Icon(
                                                              Icons.person,
                                                              size: 20,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Expanded(
                                                            child: Text(
                                                              "${diary.comments?.first.description ?? ""}",
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${diary.comments?.first.createAt ?? ""}",
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                                fontSize: 10),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                          },
                        ),
                      ],
                    ),
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
        image = File(result.files.single.path!);
      });
    } else {}
  }
}
