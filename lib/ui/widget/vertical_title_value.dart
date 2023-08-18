import 'package:flutter/material.dart';

class VerticalTitleValue extends StatelessWidget {
  const VerticalTitleValue({Key? key,required this.title, required this.value}) : super(key: key);

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
        SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16),),
      ],
    );
  }
}
