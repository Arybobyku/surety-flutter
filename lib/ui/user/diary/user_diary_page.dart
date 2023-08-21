import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';

class UserDiaryPage extends StatefulWidget {
  const UserDiaryPage({Key? key}) : super(key: key);

  @override
  State<UserDiaryPage> createState() => _UserDiaryPageState();
}

class _UserDiaryPageState extends State<UserDiaryPage> {
  File? image = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.generalBackgroundColor,
      body: SafeArea(
        child: Consumer<AuthProvider>(builder: (context, state, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${state.user.fullName ?? "-"} Diary",
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "What's on your opinion?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.public, size: 20),
                              SizedBox(
                                height: 20,
                                child: Switch(
                                  value: false,

                                  onChanged: (val) {},
                                ),
                              ),
                              Icon(Icons.lock, size: 20),
                            ],
                          ),
                        ],
                      ),
                      InputFieldRounded(
                        hint: '...',
                        onChange: (String value) {},
                      ),
                      image == null
                          ? GestureDetector(
                              onTap: () {
                                doImagePicker();
                              },
                              child: Icon(Icons.add_a_photo),
                            )
                          : Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      image = null;
                                    });
                                  },
                                  child: Icon(Icons.delete),
                                ),
                                SizedBox(width: 10),
                                Container(
                                  margin: EdgeInsets.only(top: 15, bottom: 30),
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(image!),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
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
