import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/diary_provider.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/button_rounded.dart';

import '../../../provider/auth.dart';

class UserCommunityPage extends StatefulWidget {
  const UserCommunityPage({Key? key}) : super(key: key);

  @override
  State<UserCommunityPage> createState() => _UserCommunityPageState();
}

class _UserCommunityPageState extends State<UserCommunityPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => DiaryProvider()..getAllDiaries()),
      ],
      child: Scaffold(
        backgroundColor: ColorPalette.generalBackgroundColor,
        body: Consumer<AuthProvider>(
          builder: (context,authState,_) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// Header
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Around Me",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(DateFormat('dd MMMM,yyyy').format(DateTime.now()))
                        ],
                      ),
                    ),
                    Divider(height: 10, color: Colors.black),

                    /// Content
                    // Padding(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: ButtonRounded(
                    //           text: "Friends",
                    //           onPressed: () {},
                    //         ),
                    //       ),
                    //       SizedBox(width: 20),
                    //       Expanded(
                    //         child: ButtonRounded(
                    //           text: "Near Me",
                    //           onPressed: () {},
                    //         ),
                    //       ),
                    //       SizedBox(width: 20),
                    //       Expanded(
                    //         child: ButtonRounded(
                    //           text: "Expert",
                    //           onPressed: () {},
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Consumer<DiaryProvider>(
                        builder: (context, state, _) {
                          return state.loading
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.diaries.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final diary = state.diaries[index];
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
                                                child: Text(diary.userModel
                                                    ?.fullName ??
                                                    "-"),
                                              ),
                                              diary.isPublic!
                                                  ? Icon(Icons.public)
                                                  : Icon(Icons.lock),
                                            ],
                                          ),

                                          /// Body
                                          Text(
                                            diary.description ?? "",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(height: 5),
                                          if (diary.image != null)
                                            Container(
                                              height: 180,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.all(
                                                      Radius.circular(
                                                          10)),
                                                  image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(
                                                          diary.image!))),
                                            ),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              GestureDetector(
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
                                                    false,
                                                  )
                                                      : context
                                                      .read<
                                                      DiaryProvider>()
                                                      .likeDiary(
                                                    diary,
                                                    authState.user,
                                                    false,
                                                  );
                                                },
                                                child: Icon(
                                                  diary.likes!
                                                      .where((element) =>
                                                  element.email ==
                                                      authState
                                                          .user.email)
                                                      .isNotEmpty
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                ),
                                              ),
                                              if (diary.likes!.isNotEmpty)
                                                Text(
                                                  "${diary.likes?.length ?? ""}",
                                                ),
                                              SizedBox(width: 10),
                                              GestureDetector(
                                                child: Icon(Icons.comment),
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
                                              if (diary.comments!.isNotEmpty)
                                                Text(
                                                  "${diary.comments?.length ?? ""}",
                                                ),
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
