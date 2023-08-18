import 'package:flutter/material.dart';
import 'package:surety/helper/color_palette.dart';

class ButtonPicker extends StatelessWidget {
  const ButtonPicker({Key? key,this.onTap, this.title = "Cover"}) : super(key: key);
  final Function()? onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed:onTap,
      child: Container(
        child: Row(
          children: [
            Icon(
              Icons.image,
              color: ColorPalette.generalPrimaryColor,
              size: 35,
            ),
            Text(
              this.title,
              style: TextStyle(
                  color: ColorPalette.generalPrimaryColor, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
