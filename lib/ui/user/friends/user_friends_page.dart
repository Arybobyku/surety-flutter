import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/friends_provider.dart';

class UserFriendsPage extends StatefulWidget {
  const UserFriendsPage({Key? key}) : super(key: key);

  @override
  State<UserFriendsPage> createState() => _UserFriendsPageState();
}

class _UserFriendsPageState extends State<UserFriendsPage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: context.read<FriendsProvider>()
            ..getAllUser(
              context.read<AuthProvider>().user,
            ),
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorPalette.generalBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Consumer<FriendsProvider>(builder: (context, state, _) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: state.listUser.length,
                      itemBuilder: (context, index) {
                        final user = state.listUser[index];
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
                                      return state.myFriends.friends.firstWhereOrNull(
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
                                    context
                                        .read<FriendsProvider>()
                                        .removeFriends(
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
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
