import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/model/product_model.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/product_provider.dart';
import 'package:surety/ui/widget/button_picker.dart';
import 'package:surety/ui/widget/button_rounded.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';

class AdminProductPage extends StatefulWidget {
  const AdminProductPage({Key? key}) : super(key: key);

  @override
  State<AdminProductPage> createState() => _AdminProductPageState();
}

class _AdminProductPageState extends State<AdminProductPage> {
  ProductModel productModel = ProductModel();
  File? image = null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductProvider()
            ..getAllProductByCreator(context.read<AuthProvider>().user.id!),
        ),
      ],
      builder: (context, widget) {
        return Scaffold(
          backgroundColor: ColorPalette.generalBackgroundColor,
          appBar: AppBar(
            backgroundColor: ColorPalette.generalSecondaryColor,
            title: Text("Products"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final productProvider = context.read<ProductProvider>();

              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 1,
                    color: ColorPalette.generalBackgroundColor,
                    padding: const EdgeInsets.all(10),
                    child: StatefulBuilder(
                      builder:
                          (BuildContext context, StateSetter updateStateModal) {
                        doImagePicker() async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'jpeg'],
                          );

                          if (result != null) {
                            updateStateModal(() {
                              image = File(result.files.single.path!);
                            });
                          } else {
                            // User canceled the picker
                          }
                        }

                        return ChangeNotifierProvider.value(
                          value: productProvider,
                          builder: (context, _) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    "Add Products",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  InputFieldRounded(
                                    title: "Title",
                                    hint: "Enter title",
                                    onChange: (val) {
                                      productModel.title = val;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  InputFieldRounded(
                                    title: "Description",
                                    hint: "Enter description",
                                    minLines: 5,
                                    onChange: (val) {
                                      productModel.description = val;
                                    },
                                  ),
                                  SizedBox(height: 10),
                                  InputFieldRounded(
                                    title: "Price",
                                    hint: "Price",
                                    keyboardType: TextInputType.number,
                                    minLines: 5,
                                    onChange: (val) {
                                      productModel.price = double.parse(val);
                                    },
                                  ),
                                  image != null
                                      ? Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  top: 15, bottom: 30),
                                              height: 200,
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
                                            InkWell(
                                              onTap: () {
                                                updateStateModal(() {
                                                  image = null;
                                                });
                                              },
                                              child: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                            )
                                          ],
                                        )
                                      : ButtonPicker(
                                          title: "Picture",
                                          onTap: () => doImagePicker(),
                                        ),
                                  ButtonRounded(
                                    text: "Add",
                                    onPressed: () {
                                      productModel.userModel =
                                          Provider.of<AuthProvider>(context,
                                                  listen: false)
                                              .user;
                                      doCreateProduct(
                                          productModel, image, context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Consumer<ProductProvider>(
                builder: (context, value, _) {
                  if (value.loading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          ...value.productsByCreator.map(
                            (e) => Container(
                              width: double.infinity,
                              margin: EdgeInsets.all(10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(e.picture!),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    e.title ?? "-",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(e.description ?? "-"),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<ProductProvider>()
                                          .removeProduct(e.id!);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  doCreateProduct(
      ProductModel product, File? image, BuildContext context) async {
    EasyLoading.show(status: "Loading...");

    var result =
        await context.read<ProductProvider>().createProduct(product, image);

    result.fold((l) {
      EasyLoading.dismiss();
      print("===>${l}");
      Alert(
        context: context,
        type: AlertType.error,
        title: "Error",
        desc: "Something went wrong",
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
    }, (r) {
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success Add Product")));
      Get.back();
    });
  }
}
