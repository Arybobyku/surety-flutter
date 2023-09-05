import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:surety/helper/extension/date_time_extension.dart';
import 'package:surety/model/base_form_model.dart';
import 'package:surety/model/form_model.dart';

extension FormExtension on FormModel {
  BaseFormModel? get dailyWeight {
    return this
        .weight
        .firstWhereOrNull((element) => element.date.isSameDate(DateTime.now()));
  }

  BaseFormModel? get dailyLogin {
    return this
        .login
        .firstWhereOrNull((element) => element.date.isSameDate(DateTime.now()));
  }

  List<BaseFormModel>? get dailySymptoms {
    return this
        .symptoms
        .where((element) => element.date.isSameDate(DateTime.now()))
        .toList();
  }

  BaseFormModel? get dailyExercise {
    return this
        .exercise
        .firstWhereOrNull((element) => element.date.isSameDate(DateTime.now()));
  }

  BaseFormModel? get dailyDiet {
    return this
        .diet
        .firstWhereOrNull((element) => element.date.isSameDate(DateTime.now()));
  }

  BaseFormModel? get dailyPeriod {
    return this
        .period
        .firstWhereOrNull((element) => element.date.isSameDate(DateTime.now()));
  }

  Set<String> get symptomGroupByDate {
    Set<String> value = this.symptoms.map((e) => DateFormat("yyyy-MM-dd").format(e.date)).toSet();
    return value;
  }

  int get totalPoints {
    int total = this.weight.length +
        this.exercise.length +
        this.diet.length +
        this.period.length +
        this.symptomGroupByDate.length +
        this.login.length;
    return total;
  }
}
