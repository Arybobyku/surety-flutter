import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/model/base_form_model.dart';

class UserFormDetailPage extends StatefulWidget {
  const UserFormDetailPage({Key? key}) : super(key: key);

  @override
  State<UserFormDetailPage> createState() => _UserFormDetailPageState();
}

class _UserFormDetailPageState extends State<UserFormDetailPage> {
  List<BaseFormModel>? forms = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.generalSecondaryColor,
        title: Text("History ${forms!= null && forms!.isNotEmpty ? forms!.first.key  : ""}"),
      ),
      backgroundColor: ColorPalette.generalBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 20),
                if(forms !=null)
                ...forms!.map(
                  (e) => Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          e.date.dateFormat(),
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          e.value,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
