import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/enum/form_enums.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/model/base_form_model.dart';

class UserFormDetailPage extends StatefulWidget {
  const UserFormDetailPage({Key? key}) : super(key: key);

  @override
  State<UserFormDetailPage> createState() => _UserFormDetailPageState();
}

class _UserFormDetailPageState extends State<UserFormDetailPage> {
  List<BaseFormModel>? forms = Get.arguments['content'];
  String? title = Get.arguments['title'];
  bool isSymptoms = false;
  List<SymptomsGroupModel> symptomsGroup = [];
  Set<DateTime> dateValue = {};

  @override
  void initState() {
    forms?.sort((a, b) => b.date.compareTo(a.date));

    if (forms != null && forms!.isNotEmpty) {
      dateValue = forms!.map((e) => e.date).toSet();
    }

    if (forms != null &&
        forms!.isNotEmpty &&
        forms?.first.key == FormType.Symptoms.name) {
      isSymptoms = true;
      Set<String> dateMap =
          forms!.map((e) => DateFormat("dd-MM-yyyy").format(e.date)).toSet();

      dateMap.forEach((element) {
        final result = forms!
            .where((formValue) => formValue.date.dateFormat() == element)
            .toList();

        List<String> stringValue = [];
        result.forEach((element) {
          stringValue.add(element.value);
        });

        symptomsGroup
            .add(SymptomsGroupModel(date: element, value: stringValue));
      });
    }

    print("Symptomps values ${isSymptoms}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.generalSecondaryColor,
        title: Text(
            "History ${title ?? "" }"),
      ),
      backgroundColor: ColorPalette.generalBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                if (forms != null &&
                    forms!.isNotEmpty &&
                    forms?.first.key == FormType.Period.name)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () async {
                          print("ONCLICK");
                          var results = await showCalendarDatePicker2Dialog(
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              calendarType: CalendarDatePicker2Type.multi,
                            ),
                            dialogSize: const Size(325, 400),
                            value: [
                              ...dateValue
                            ],
                            borderRadius: BorderRadius.circular(15),
                          );
                          // await CalendarDatePicker2(
                          //   config: CalendarDatePicker2Config(
                          //     calendarType: CalendarDatePicker2Type.multi,
                          //   ),
                          //   value: [
                          //     ...dateValue,
                          //   ],
                          //   onValueChanged: (dates) {},
                          // );
                        },
                        child: Icon(Icons.calendar_month),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                if (isSymptoms)
                  ...symptomsGroup.map(
                    (e) => Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            e.date,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          ...e.value.map(
                            (value) => Text(
                              value,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (forms != null && !isSymptoms)
                  ...forms!.map(
                    (e) => Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 10),
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
                          if (e.value2 != null)
                            Text(
                              e.value2!,
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

class SymptomsGroupModel {
  String date;
  List<String> value;

  SymptomsGroupModel({required this.date, required this.value});
}
