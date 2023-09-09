import 'package:get/get.dart';
import 'package:surety/helper/enum/form_enums.dart';
import 'package:surety/model/base_form_model.dart';
import 'package:surety/model/form_model.dart';

extension ListFormModelExtension on List<BaseFormModel>? {
  int get countStars {
    final login =
        this!.firstWhereOrNull((element) => element.key == "Login") != null
            ? 1
            : 0;
    final weight =
        this!.firstWhereOrNull((element) => element.key == "Weight") != null
            ? 1
            : 0;
    final exercise =
        this!.firstWhereOrNull((element) => element.key == "Exercise") != null
            ? 1
            : 0;
    final period =
        this!.firstWhereOrNull((element) => element.key == "Period") != null
            ? 1
            : 0;
    final diet =
        this!.firstWhereOrNull((element) => element.key == "Diet") != null
            ? 1
            : 0;
    final symptoms =
        this!.firstWhereOrNull((element) => element.key == "Symptoms") != null
            ? 1
            : 0;
    return login + weight + exercise + period + diet + symptoms;
  }
}
