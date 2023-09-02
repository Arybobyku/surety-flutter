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
  FormModel formModel = FormModel(
    login: [],
    symptoms: [],
    period: [],
    diet: [],
    exercise: [],
    weight: [],
    userId: '',
  );

  Future<bool> getFormById(UserModel user) async {
    try {
      loading = true;
      final result = await _formService.getFormById(user.id!);
      if (result != null) {
        formModel = result;
      }
      if (formModel.dailyLogin == null) {
        await update(FormType.Login, "1", user);
        return true;
      }
      loading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> update(FormType type, String value, UserModel userModel) async {
    formModel.userId = userModel.id!;
    try {
      if (type == FormType.Login) {
        dailyLogin = true;
        formModel.login.add(
            BaseFormModel(key: "Login", date: DateTime.now(), value: value));
      }
      if (type == FormType.Weight) {
        formModel.weight.add(
            BaseFormModel(key: "Weight", date: DateTime.now(), value: value));
      }
      if (type == FormType.Exercise) {
        formModel.exercise.add(
            BaseFormModel(key: "Exercise", date: DateTime.now(), value: value));
      }
      if (type == FormType.Period) {
        formModel.period.add(
            BaseFormModel(key: "Period", date: DateTime.now(), value: value));
      }
      if (type == FormType.Diet) {
        formModel.diet.add(
            BaseFormModel(key: "Diet", date: DateTime.now(), value: value));
      }
      if (type == FormType.Symptoms) {
        formModel.symptoms.add(
            BaseFormModel(key: "Symptoms", date: DateTime.now(), value: value));
      }

      final result = await _formService.update(formModel);
      formModel = result;
      notifyListeners();
    } catch (e) {
      print("ERROR FORM" + e.toString());
    }
  }
}