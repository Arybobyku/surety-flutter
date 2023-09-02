import 'dart:math';

import 'package:surety/model/base_form_model.dart';

class FormModel {
  List<BaseFormModel> login;
  List<BaseFormModel> symptoms;
  List<BaseFormModel> period;
  List<BaseFormModel> diet;
  List<BaseFormModel> exercise;
  List<BaseFormModel> weight;
  String userId;

  FormModel({
    required this.login,
    required this.symptoms,
    required this.period,
    required this.diet,
    required this.exercise,
    required this.weight,
    required this.userId,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) => FormModel(
        login: json['login'] != null
            ? List<BaseFormModel>.from(json['login'].map((e) {
                return BaseFormModel.fromJson(e as Map<String, dynamic>);
              }).toList())
            : [],
        symptoms: json['symptoms'] != null
            ? List<BaseFormModel>.from(json['symptoms'].map((e) {
                return BaseFormModel.fromJson(e as Map<String, dynamic>);
              }).toList())
            : [],
        period: json['period'] != null
            ? List<BaseFormModel>.from(json['period'].map((e) {
                return BaseFormModel.fromJson(e as Map<String, dynamic>);
              }).toList())
            : [],
        diet: json['diet'] != null
            ? List<BaseFormModel>.from(json['diet'].map((e) {
                return BaseFormModel.fromJson(e as Map<String, dynamic>);
              }).toList())
            : [],
        exercise: json['exercise'] != null
            ? List<BaseFormModel>.from(json['exercise'].map((e) {
                return BaseFormModel.fromJson(e as Map<String, dynamic>);
              }).toList())
            : [],
        weight: json['weight'] != null
            ? List<BaseFormModel>.from(json['weight'].map((e) {
                return BaseFormModel.fromJson(e as Map<String, dynamic>);
              }).toList())
            : [],
        userId: json['userId'],
      );

  toJson() => {
        'symptoms': symptoms.map((e) => e.toJson()).toList(),
        'period': period.map((e) => e.toJson()).toList(),
        'diet': diet.map((e) => e.toJson()).toList(),
        'exercise': exercise.map((e) => e.toJson()).toList(),
        'weight': weight.map((e) => e.toJson()).toList(),
        'login': login.map((e) => e.toJson()).toList(),
        'userId': userId,
      };
}
