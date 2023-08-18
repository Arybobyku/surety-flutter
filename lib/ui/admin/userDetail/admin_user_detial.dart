import 'package:surety/helper/constants.dart';
import 'package:surety/provider/admin.dart';
import 'package:surety/ui/widget/vertical_title_value.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminUserDetailPage extends StatefulWidget {
  const AdminUserDetailPage({Key? key}) : super(key: key);

  @override
  _AdminUserDetailState createState() => _AdminUserDetailState();
}

class _AdminUserDetailState extends State<AdminUserDetailPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AdminProvider>(builder: (context, value, _) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: kRoundedContainer.copyWith(
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: value.selectedUser.photoProfile ?? "",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                size: 40,
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 5),
                                      Text(
                                        "ID",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15),
                            VerticalTitleValue(
                                title: 'Full Name',
                                value: value.selectedUser.fullName),
                            SizedBox(height: 15),
                            VerticalTitleValue(
                                title: 'Email',
                                value: value.selectedUser.email),
                            SizedBox(height: 15),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
