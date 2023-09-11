import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/helper/extension/form_extension.dart';
import 'package:surety/helper/extension/list_extension.dart';
import 'package:surety/model/base_form_model.dart';
import 'package:surety/model/form_model.dart';
import 'package:surety/routes.dart';

class UserTrackingPage extends StatefulWidget {
  const UserTrackingPage({Key? key}) : super(key: key);

  @override
  State<UserTrackingPage> createState() => _UserTrackingPageState();
}

class _UserTrackingPageState extends State<UserTrackingPage> {
  FormModel forms = Get.arguments;
  Map<String, List<BaseFormModel>> selected = {};
  bool isUsingFilter = false;

  @override
  void initState() {
    selected = forms.pointsGroupByDate;
    super.initState();
  }

  reset() {
    selected = forms.pointsGroupByDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.generalSecondaryColor,
        title: Text('Tracking Journal'),
      ),
      backgroundColor: ColorPalette.generalBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Tracking Journal",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                    if (isUsingFilter)
                      InkWell(
                        onTap: () {
                          setState(() {
                            reset();
                            isUsingFilter = false;
                          });
                        },
                        child: Text(
                          "reset",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    InkWell(
                      onTap: () async {
                        final result = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );

                        print(result);
                        if (result != null) {
                          isUsingFilter = true;
                          setState(() {
                            if (forms.pointsGroupByDate[result.dateFormat()] !=
                                null) {
                              selected = {
                                result.dateFormat(): forms
                                    .pointsGroupByDate[result.dateFormat()]!
                              };
                            } else {
                              selected = {};
                            }
                          });
                        } else {
                          setState(() {
                            selected = {};
                          });
                        }
                      },
                      child: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Divider(
                  height: 2,
                  color: Colors.black,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selected.length,
                  itemBuilder: (context, index) {
                    final key = selected.keys.elementAt(index);
                    final points = selected[key];
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          DateTime date = DateFormat("dd-MM-yyyy").parse(key);
                          print("DATE $key");
                          print("MA DATE ${date}");

                          final result = forms.mergeAllForm
                              .where((element) => element.date.isSameDate(date))
                              .toList();

                          print("RESULT ${result.length}");

                          Get.toNamed(Routes.userFormDetail, arguments: result);
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: ColorPalette.generalDarkPrimaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 4),
                                  Icon(Icons.star,
                                      color: points.countStars >= 3
                                          ? ColorPalette.generalCupColor
                                          : ColorPalette.generalSoftGrey,
                                      size: 25),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: ColorPalette.generalCupColor,
                                          size: 25),
                                      Image.asset(
                                        "images/cup.png",
                                        width: 30,
                                      ),
                                      Icon(Icons.star,
                                          color: points.countStars >= 6
                                              ? ColorPalette.generalCupColor
                                              : ColorPalette.generalSoftGrey,
                                          size: 25),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 105,
                              margin: EdgeInsets.only(top: 80),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: ColorPalette.generalDarkPrimaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              alignment: Alignment.center,
                              child: Text(
                                "${key}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
