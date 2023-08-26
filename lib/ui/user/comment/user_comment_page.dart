import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/helper/extension/string_extension.dart';
import 'package:surety/model/comment_model.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/diary_provider.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';
import 'package:surety/ui/widget/video_widget.dart';

class UserCommentPage extends StatefulWidget {
  const UserCommentPage({Key? key}) : super(key: key);

  @override
  State<UserCommentPage> createState() => _UserCommentPageState();
}

class _UserCommentPageState extends State<UserCommentPage> {
  DiaryProvider diaryProvider = Get.arguments;
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: diaryProvider),
      ],
      child: Consumer<AuthProvider>(builder: (context, authState, _) {
        return Scaffold(
          backgroundColor: ColorPalette.generalBackgroundColor,
          body: Consumer<DiaryProvider>(builder: (context, state, _) {
            final diary = state.detail;
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Header
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          diary.userModel?.photoProfile ?? "",
                                      imageBuilder: (context, imageProvider) =>
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
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.person,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            diary.userModel?.fullName ?? "-",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          if (diary.isExpert!)
                                            Row(
                                              children: [
                                                Icon(Icons.stars_sharp,
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
                                          diary.createdAt!.timeAgoFormat(),
                                          style: TextStyle(fontSize: 11),
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
                                              "keydata1",
                                            ),
                                          )
                                        : Container(
                                            height: 180,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              image: DecorationImage(
                                                fit: BoxFit.fitHeight,
                                                image:
                                                    NetworkImage(diary.image!),
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
                                                    authState.user.email)
                                                .isNotEmpty
                                            ? context
                                                .read<DiaryProvider>()
                                                .unLikeDiary(
                                                  diary,
                                                  authState.user,
                                                  true,
                                                )
                                            : context
                                                .read<DiaryProvider>()
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
                                                        element.email ==
                                                        authState.user.email)
                                                    .isNotEmpty
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: ColorPalette.generalPrimaryColor,
                                      ),
                                    ),
                                    if (diary.likes != null &&
                                        diary.likes!.isNotEmpty)
                                      Text(
                                        "${diary.likes?.length ?? ""}",
                                        style: TextStyle(
                                          color:
                                              ColorPalette.generalPrimaryColor,
                                        ),
                                      ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.comment,
                                      color: ColorPalette.generalPrimaryColor,
                                    ),
                                    if (diary.comments != null &&
                                        diary.comments!.isNotEmpty)
                                      Text(
                                        "${diary.comments?.length ?? ""}",
                                        style: TextStyle(
                                          color:
                                              ColorPalette.generalPrimaryColor,
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: diary.comments?.length ?? 0,
                            itemBuilder: (context, index) {
                              final comment = diary.comments![index];
                              return Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              comment.userModel?.photoProfile ??
                                                  "",
                                          imageBuilder:
                                              (context, imageProvider) =>
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
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.person,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              comment.userModel?.fullName ?? "",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(comment.description ?? ""),
                                            Text(
                                              comment.createAt ?? "",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: InputFieldRounded(
                          controller: commentController,
                          hint: "...",
                          onChange: (String value) {},
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          context.read<DiaryProvider>().addComment(
                                diary,
                                CommentModel(
                                  userModel: authState.user,
                                  description: commentController.value.text,
                                  createAt: DateFormat('dd MMMM,yyyy')
                                      .format(DateTime.now()),
                                ),
                              );
                          setState(() {
                            commentController = TextEditingController();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }),
        );
      }),
    );
  }
}
