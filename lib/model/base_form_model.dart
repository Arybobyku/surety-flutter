import 'package:intl/intl.dart';

class BaseFormModel {
  String key;
  DateTime date;
  String value;
  String? value2;

  BaseFormModel({
    required this.key,
    required this.date,
    required this.value,
     this.value2,
  });

  factory BaseFormModel.fromJson(Map<String, dynamic> json) => BaseFormModel(
        key: json['key'],
        date: DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['date']),
        value: json['value'],
        value2: json['value2'],
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
        'value2': value2,
        'date': date.toString(),
      };
}
