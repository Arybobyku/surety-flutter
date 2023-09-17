import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:surety/model/article_model.dart';
import 'package:surety/provider/article_provider.dart';
import 'package:surety/ui/widget/button_rounded.dart';

import '../../widget/input_field_rounded.dart';

class AdminArticleDetailPage extends StatefulWidget {
  const AdminArticleDetailPage({Key? key}) : super(key: key);

  @override
  State<AdminArticleDetailPage> createState() => _AdminArticleDetailPageState();
}

class _AdminArticleDetailPageState extends State<AdminArticleDetailPage> {
  final ArticleModel articleModel = Get.arguments['article'];
  final ArticleProvider providerValue = Get.arguments['provider'];
  File? photoProfile = null;

  @override
  Widget build(BuildContext context) {
    print(providerValue.articlesByCreator.length);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: providerValue),
      ],
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  articleModel.picture != null && photoProfile == null
                      ? CachedNetworkImage(
                          imageUrl: articleModel.picture ?? "",
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
                  InputFieldRounded(
                    title: "Title",
                    hint: "Enter title",
                    initialValue: articleModel.title,
                    onChange: (val) {
                      articleModel.title = val;
                    },
                  ),
                  SizedBox(height: 10),
                  InputFieldRounded(
                    title: "Description",
                    hint: "Enter description",
                    initialValue: articleModel.description,
                    minLines: 5,
                    onChange: (val) {
                      articleModel.description = val;
                    },
                  ),
                  SizedBox(height: 10),
                  InputFieldRounded(
                    title: "Link",
                    hint: "Link",
                    initialValue: articleModel.link,
                    minLines: 5,
                    onChange: (val) {
                      articleModel.link = val;
                    },
                  ),
                  ButtonRounded(
                    text: "Update",
                    onPressed: () async {
                      await providerValue.updateArticle(
                          photoProfile, articleModel);
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
