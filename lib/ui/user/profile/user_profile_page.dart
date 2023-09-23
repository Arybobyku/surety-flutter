import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/constants.dart';
import 'package:surety/helper/enum/form_enums.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/helper/extension/form_extension.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/form_provider.dart';
import 'package:surety/routes.dart';
import 'package:surety/ui/widget/button_rounded.dart';
import 'package:surety/ui/widget/dropdown_container.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AuthProvider>(builder: (context, valueAuth, _) {
        return Scaffold(
          backgroundColor: ColorPalette.generalBackgroundColor,
          body: Consumer<FormProvider>(builder: (context, stateForm, _) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///  Header
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorPalette.generalSecondaryColor,
                    ),
                    child: Row(
                      children: [
                        CachedNetworkImage(
                          imageUrl: valueAuth.user.photoProfile ?? "",
                          imageBuilder: (context, imageProvider) => Container(
                            width: 50.0,
                            height: 50.0,
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
                            size: 40,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            child: Text(
                          "${valueAuth.user.fullName}",
                          style: TextStyle(fontSize: 18),
                        )),
                        SizedBox(width: 10),
                        // InkWell(
                        //   onTap: () => Get.toNamed(Routes.userTrackingPage,
                        //       arguments: stateForm.formModel),
                        //   child: Container(
                        //     padding: EdgeInsets.all(5),
                        //     decoration: BoxDecoration(
                        //       color: Colors.white,
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(10)),
                        //     ),
                        //     child: Column(
                        //       children: [
                        //         Image.asset("images/cup.png",
                        //             width: 30, height: 20),
                        //         Text(
                        //           "${stateForm.formModel.totalPoints ?? "-"}",
                        //           style: TextStyle(fontSize: 16),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(width: 10),

                        InkWell(
                          onTap: () => Get.toNamed(Routes.userProfileDetail),
                          child: Icon(Icons.edit),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: Text(DateTime.now().dateFormat())),
                        InkWell(
                          onTap: () => Get.toNamed(Routes.userTrackingPage,
                              arguments: stateForm.formModel),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: ColorPalette.generalSecondaryColor),
                            child: Text("Tracking Journal"),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(height: 8, color: Colors.black),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //symptoms
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "what are your Symptoms Today?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Get.toNamed(
                                Routes.userFormDetail,
                                arguments: {
                                  "content": stateForm.formModel.symptoms,
                                  "title": FormType.Symptoms.name,
                                },
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.history,
                                        color: ColorPalette.generalPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        GridView.builder(
                          itemCount: symptomsList.length,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 5,
                            childAspectRatio: 1.9,
                          ),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                if (stateForm.formModel.symptoms
                                        .firstWhereOrNull((element) =>
                                            (element.value ==
                                                symptomsList[index]) &&
                                            element.date
                                                .isSameDate(DateTime.now())) ==
                                    null) {
                                  context.read<FormProvider>().update(
                                        FormType.Symptoms,
                                        symptomsList[index],
                                        context.read<AuthProvider>().user,
                                      );
                                } else {
                                  context
                                      .read<FormProvider>()
                                      .removeSymptoms(symptomsList[index]);
                                }
                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  color: ColorPalette.generalPrimaryColor,
                                  border: stateForm.formModel.symptoms
                                              .firstWhereOrNull((element) =>
                                                  (element.value ==
                                                      symptomsList[index]) &&
                                                  element.date.isSameDate(
                                                      DateTime.now())) !=
                                          null
                                      ? Border.all(
                                          width: 2,
                                          color: ColorPalette
                                              .generalDarkPrimaryColor)
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  symptomsList[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        if (stateForm.formModel.dailySymptoms?.firstWhereOrNull(
                                (element) => element.value2 != null) !=
                            null)
                          GridView.builder(
                            itemCount: stateForm.formModel.dailySymptoms
                                ?.where((element) => element.value2 != null)
                                .toList()
                                .length,
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 5,
                              childAspectRatio: 1.9,
                            ),
                            itemBuilder: (context, index) {
                              final symptomInput = stateForm
                                  .formModel.dailySymptoms
                                  ?.where((element) => element.value2 != null)
                                  .toList();
                              return Container(
                                padding: EdgeInsets.all(5),
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: ColorPalette.generalPrimaryColor,
                                    border: Border.all(
                                        width: 2,
                                        color: ColorPalette
                                            .generalDarkPrimaryColor)),
                                alignment: Alignment.center,
                                child: Text(
                                  symptomInput?[index].value ?? "-",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: ColorPalette.generalPrimaryColor,
                          ),
                          child: TextButton(
                            onPressed: () {
                              showBottomModel(
                                context,
                                valueAuth.user,
                                FormType.Symptoms,
                              );
                            },
                            child: Text(
                              "+Add",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  text: "Track Period",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.water_drop,
                                        color: ColorPalette.generalPrimaryColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => Get.toNamed(
                                Routes.userFormDetail,
                                arguments: {
                                  "content": stateForm.formModel.period,
                                  "title": FormType.Period.name,
                                },
                              ),
                              child: Icon(Icons.history,
                                  color: ColorPalette.generalPrimaryColor),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Slider(
                          activeColor: ColorPalette.generalPrimaryColor,
                          value: stateForm.periodProgress,
                          min: 0,
                          max: 100,
                          onChanged: (val) {
                            context
                                .read<FormProvider>()
                                .onChangePeriodTrack(val);
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              "Light",
                              style: TextStyle(fontSize: 16),
                            )),
                            Expanded(
                                child: Text(
                              "Medium",
                              style: TextStyle(fontSize: 16),
                            )),
                            Text(
                              "Heavy",
                              style: TextStyle(fontSize: 16),
                            )
                          ],
                        ),
                        if (stateForm.formModel.dailyPeriod == null)
                          ButtonRounded(
                            text: "Add",
                            onPressed: () {
                              context.read<FormProvider>().update(
                                  FormType.Period,
                                  "${stateForm.periodProgress}",
                                  context.read<AuthProvider>().user);
                            },
                          ),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: "Diet",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.food_bank,
                                  color: ColorPalette.generalPrimaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        //Diet
                        SizedBox(height: 10),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => stateForm.formModel.dailyDiet == null
                                  ? showBottomModel(
                                      context,
                                      valueAuth.user,
                                      FormType.Diet,
                                    )
                                  : showSnackBar(context, FormType.Diet),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.insights,
                                        color: ColorPalette
                                            .generalDarkPrimaryColor,
                                        size: 20,
                                      ),
                                      alignment: PlaceholderAlignment.middle,
                                    ),
                                    TextSpan(
                                      text: "Daily Calories",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            InkWell(
                              onTap: () => Get.toNamed(
                                Routes.userFormDetail,
                                arguments: {
                                  "content": stateForm.formModel.diet,
                                  "title": FormType.Diet.name,
                                },
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.bar_chart,
                                        color: ColorPalette
                                            .generalDarkPrimaryColor,
                                        size: 20,
                                      ),
                                      alignment: PlaceholderAlignment.middle,
                                    ),
                                    TextSpan(
                                      text: "Previous Calories",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: "Exercise",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.fitness_center,
                                  color: ColorPalette.generalPrimaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        //Exercise
                        Row(
                          children: [
                            InkWell(
                              onTap: () => stateForm.formModel.dailyExercise ==
                                      null
                                  ? showBottomModel(
                                      context,
                                      valueAuth.user,
                                      FormType.Exercise,
                                    )
                                  : showSnackBar(context, FormType.Exercise),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.edit_document,
                                        color: ColorPalette
                                            .generalDarkPrimaryColor,
                                        size: 20,
                                      ),
                                      alignment: PlaceholderAlignment.middle,
                                    ),
                                    TextSpan(
                                      text: "Daily",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 70),
                            InkWell(
                              onTap: () => Get.toNamed(
                                Routes.userFormDetail,
                                arguments: {
                                  "content": stateForm.formModel.exercise,
                                  "title": FormType.Exercise.name,
                                },
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.bar_chart,
                                        color: ColorPalette
                                            .generalDarkPrimaryColor,
                                        size: 20,
                                      ),
                                      alignment: PlaceholderAlignment.middle,
                                    ),
                                    TextSpan(
                                      text: "Previous",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: "Weight",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.monitor_weight,
                                  color: ColorPalette.generalPrimaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        //Weight
                        Row(
                          children: [
                            InkWell(
                              onTap: () =>
                                  stateForm.formModel.dailyWeight == null
                                      ? showBottomModel(
                                          context,
                                          valueAuth.user,
                                          FormType.Weight,
                                        )
                                      : showSnackBar(context, FormType.Weight),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.sunny,
                                        color: ColorPalette
                                            .generalDarkPrimaryColor,
                                        size: 20,
                                      ),
                                      alignment: PlaceholderAlignment.middle,
                                    ),
                                    TextSpan(
                                      text: "Today",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 60),
                            InkWell(
                              onTap: () => Get.toNamed(
                                Routes.userFormDetail,
                                arguments: {
                                  "content": stateForm.formModel.weight,
                                  "title": FormType.Weight.name,
                                },
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      child: Icon(
                                        Icons.waterfall_chart,
                                        color: ColorPalette
                                            .generalDarkPrimaryColor,
                                        size: 20,
                                      ),
                                      alignment: PlaceholderAlignment.middle,
                                    ),
                                    TextSpan(
                                      text: "Weight Logs",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 150),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      }),
    );
  }

  showSnackBar(context, FormType formType) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You've added ${formType.name} for today")));
  }

  showBottomModel(BuildContext context, UserModel user, FormType type) {
    String value = '';
    String valueExercise = '';
    String valueExercise2 = 'Light';
    String value2 = '';
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, StateSetter updateStateModal) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20,
                  right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Container(
                    height: 3,
                    width: 80,
                    decoration: BoxDecoration(
                        color: ColorPalette.generalDarkGrey,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Form ${type.name}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  type == FormType.Exercise
                      ? Column(
                          children: [
                            InputFieldRounded(
                              title: "Hours",
                              hint: '...',
                              keyboardType: TextInputType.number,
                              onChange: (val) {
                                print("ON CHANGE $val");
                                valueExercise = val;

                                print("valueExercise $valueExercise");
                              },
                            ),
                            DropdownContainer(
                              value: valueExercise2,
                              onChanged: (val) {
                                updateStateModal(() {
                                  valueExercise2 = val!;
                                });
                              },
                              items: ["Light", "Medium", "High"],
                              hint: 'Intensity of exercise',
                            ),
                          ],
                        )
                      : InputFieldRounded(
                          hint: '${type.name}',
                          onChange: (val) {
                            value = val;
                          },
                        ),
                  ButtonRounded(
                    text: "Add",
                    onPressed: () {
                      if (type == FormType.Symptoms) {
                        context
                            .read<FormProvider>()
                            .update(type, value, user, value2: "input");
                      } else if (type == FormType.Exercise) {
                        if (valueExercise != '' && valueExercise2 != '') {
                          context.read<FormProvider>().update(
                                type,
                                valueExercise,
                                user,
                                value2: valueExercise2,
                              );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill all the form input")));
                        }
                      } else {
                        if (value != '') {
                          context
                              .read<FormProvider>()
                              .update(type, value, user, value2: value2);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please fill the form input")));
                        }
                      }

                      Get.back();
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
