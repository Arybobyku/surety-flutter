import 'package:intl/intl.dart';

class BaseFormModel {
  String key;
  DateTime date;
  String value;

  BaseFormModel({
    required this.key,
    required this.date,
    required this.value,
  });

  factory BaseFormModel.fromJson(Map<String, dynamic> json) => BaseFormModel(
        key: json['key'],
        date: DateFormat("yyyy-MM-dd hh:mm:ss").parse(json['date']),
        value: json['value'],
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'value': value,
        'date': date.toString(),
      };
}
