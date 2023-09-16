import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/helper/extension/string_extension.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/diary_provider.dart';
import 'package:surety/provider/friends_provider.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/video_widget.dart';

class UserFriendsDetailPage extends StatefulWidget {
  const UserFriendsDetailPage({Key? key}) : super(key: key);

  @override
  State<UserFriendsDetailPage> createState() => _UserFriendsDetailPageState();
}

class _UserFriendsDetailPageState extends State<UserFriendsDetailPage> {
  UserModel user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DiaryProvider()..getFriendsDiary(user.id!),
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorPalette.generalBackgroundColor,
        body: SafeArea(
          child: Consumer<AuthProvider>(builder: (context, authState, _) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    //Header
                    Consumer<FriendsProvider>(builder: (context, state, _) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: "${user.photoProfile}",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                size: 50,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${user.fullName}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (user.expertise != null)
                                    Text(
                                      "Experts",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return ColorPalette.generalPrimaryColor;
                                    }
                                    return state.myFriends.friends
                                                .firstWhereOrNull(
                                                    (e) => e.id == user.id) !=
                                            null
                                        ? ColorPalette.generalSecondaryColor
                                        : ColorPalette.generalPrimaryColor;
                                  },
                                ),
                              ),
                              onPressed: () {
                                if (state.myFriends.friends.firstWhereOrNull(
                                        (e) => e.id == user.id) !=
                                    null) {
                                  context.read<FriendsProvider>().removeFriends(
                                        user,
                                        context.read<AuthProvider>().user,
                                      );
                                } else {
                                  context.read<FriendsProvider>().addFriends(
                                        user,
                                        context.read<AuthProvider>().user,
                                      );
                                }
                              },
                              child: Text(
                                state.myFriends.friends.firstWhereOrNull(
                                            (e) => e.id == user.id) !=
                                        null
                                    ? "Unfollow"
                                    : "Follow",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 10),
                    Divider(height: 4),
                    SizedBox(height: 10),
                    Consumer<DiaryProvider>(
                      builder: (context, state, _) {
                        return state.loading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.friendsDiary.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final diary = state.friendsDiary[index];
                                  return Container(
                                    padding: EdgeInsets.all(15),
                                    margin: EdgeInsets.symmetric(vertical: 10),
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
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                Icons.person,
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "${diary.userModel?.fullName ?? ""}'s diary  ",
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      if (diary.isExpert!)
                                                        Icon(Icons.stars_sharp,
                                                            size: 18),
                                                      if (diary.isExpert!)
                                                        Text("Expert"),
                                                    ],
                                                  ),
                                                  if (diary.isExpert!)
                                                    Text(
                                                      "${diary.userModel?.bio}",
                                                      style: TextStyle(
                                                          fontSize: 12),
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
                                                  style:
                                                      TextStyle(fontSize: 11),
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
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(10),
                                                      ),
                                                      image: DecorationImage(
                                                        fit: BoxFit.fitHeight,
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
                                                        .read<DiaryProvider>()
                                                        .unLikeDiary(
                                                          diary,
                                                          authState.user,
                                                          false,
                                                        )
                                                    : context
                                                        .read<DiaryProvider>()
                                                        .likeDiary(
                                                          diary,
                                                          authState.user,
                                                          false,
                                                        );
                                              },
                                              child: Icon(
                                                diary.likes != null &&
                                                        diary.likes!
                                                            .where((element) =>
                                                                element.email ==
                                                                authState
                                                                    .user.email)
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
                                                  arguments: context
                                                      .read<DiaryProvider>(),
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
                                                    CrossAxisAlignment.start,
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
                                                            shape:
                                                                BoxShape.circle,
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  imageProvider,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                        placeholder: (context,
                                                                url) =>
                                                            CircularProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
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
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        "${diary.comments?.first.createAt ?? ""}",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                        overflow: TextOverflow
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
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
