import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surety/model/product_model.dart';
import 'package:surety/provider/product_provider.dart';
import 'package:surety/ui/widget/button_rounded.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';

class AdminProductDetailPage extends StatefulWidget {
  const AdminProductDetailPage({Key? key}) : super(key: key);

  @override
  State<AdminProductDetailPage> createState() => _AdminProductDetailPageState();
}

class _AdminProductDetailPageState extends State<AdminProductDetailPage> {
  final ProductModel productModel = Get.arguments['product'];
  final ProductProvider providerValue = Get.arguments['provider'];
  File? photoProfile = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                productModel.picture != null && photoProfile == null
                    ? CachedNetworkImage(
                        imageUrl: productModel.picture ?? "",
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
                                  margin: EdgeInsets.only(top: 15, bottom: 30),
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
                                    child: Icon(Icons.delete, color: Colors.red),
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
                  initialValue: productModel.title,
                  onChange: (val) {
                    productModel.title = val;
                  },
                ),
                SizedBox(height: 10),
                InputFieldRounded(
                  title: "Description",
                  hint: "Enter description",
                  initialValue: productModel.description,
                  minLines: 5,
                  onChange: (val) {
                    productModel.description = val;
                  },
                ),
                SizedBox(height: 10),
                InputFieldRounded(
                  title: "Link",
                  hint: "Link",
                  initialValue: productModel.link,
                  minLines: 5,
                  onChange: (val) {
                    productModel.link = val;
                  },
                ),
                SizedBox(height: 10),
                InputFieldRounded(
                  title: "Price",
                  hint: "Price",
                  initialValue: productModel.price.toString(),
                  keyboardType: TextInputType.number,
                  minLines: 5,
                  onChange: (val) {
                    productModel.price = double.parse(val);
                  },
                ),
                SizedBox(height: 10),
                ButtonRounded(
                  text: "Update",
                  onPressed: () async {
                    await providerValue.updateProduct(photoProfile, productModel);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Success Update Products")));
                  },
                ),
              ],
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
