import 'package:flutter/material.dart';
import 'package:surety/helper/enum/form_enums.dart';
import 'package:surety/helper/extension/form_extension.dart';
import 'package:surety/model/base_form_model.dart';
import 'package:surety/model/form_model.dart';
import 'package:surety/model/user_model.dart';
import 'package:surety/service/form_service.dart';

class FormProvider extends ChangeNotifier {
  FormService _formService = FormService();
  bool loading = true;
  bool dailyLogin = false;
  double periodProgress = 50;
  FormModel formModel = FormModel(
    mood: [],
    login: [],
    symptoms: [],
    period: [],
    diet: [],
    exercise: [],
    weight: [],
    userId: '',
  );

  void onChangePeriodTrack(double value) {
    this.periodProgress = value;
    notifyListeners();
  }

  Future<void> getFormById(UserModel user) async {
    try {
      print("TESTING");
      loading = true;
      final result = await _formService.getFormById(user.id!);
      if (result != null) {
        formModel = result;
      }
      if (formModel.dailyLogin == null) {
        await update(FormType.Login, "1", user);
        dailyLogin = true;
      }
      loading = false;
      dailyLogin = false;
      notifyListeners();
    } catch (e) {
      print(e);
      dailyLogin = false;
    }
  }

  Future<void> update(FormType type, String value, UserModel userModel,
      {String? value2}) async {
    formModel.userId = userModel.id!;
    try {
      if (type == FormType.Mood) {
        formModel.mood.add(
            BaseFormModel(key: "Mood", date: DateTime.now(), value: value));
      }
      if (type == FormType.Login) {
        dailyLogin = true;
        formModel.login.add(
            BaseFormModel(key: "Login", date: DateTime.now(), value: value));
      }
      if (type == FormType.Weight) {
        formModel.weight.add(BaseFormModel(
            key: "Weight", date: DateTime.now(), value: value + " Kg"));
      }
      if (type == FormType.Exercise) {
        formModel.exercise.add(
          BaseFormModel(
            key: "Exercise",
            date: DateTime.now(),
            value: value + " Hours",
            value2: value2,
          ),
        );
      }
      if (type == FormType.Period) {
        print(value);
        String periodValue = "";
        if (double.parse(value) == 50) {
          periodValue = "Medium";
        } else if (double.parse(value) > 50) {
          periodValue = "Heavy";
        } else {
          periodValue = "Light";
        }
        formModel.period.add(BaseFormModel(
            key: "Period", date: DateTime.now(), value: periodValue));
      }
      if (type == FormType.Diet) {
        formModel.diet.add(
            BaseFormModel(key: "Diet", date: DateTime.now(), value: value));
      }
      if (type == FormType.Symptoms) {
        formModel.symptoms.add(BaseFormModel(
          key: "Symptoms",
          date: DateTime.now(),
          value: value,
          value2: value2,
        ));
      }

      final result = await _formService.update(formModel);
      formModel = result;
      notifyListeners();
    } catch (e) {
      print("ERROR FORM" + e.toString());
    }
  }
}
