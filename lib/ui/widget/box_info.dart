import 'package:flutter/material.dart';
import 'package:surety/helper/color_palette.dart';

class BoxInfo extends StatelessWidget {
  const BoxInfo({
    Key? key,
    required this.title,
    required this.value,
    this.backgroundColor = ColorPalette.generalSoftOrange,
    this.onTap
  }) : super(key: key);
  final String title;
  final String value;
  final Function()? onTap;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color:backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
