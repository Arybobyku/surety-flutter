import 'package:flutter/material.dart';
import 'package:surety/helper/color_palette.dart';

class HorizontalIconLabel extends StatelessWidget {
  const HorizontalIconLabel(
      {Key? key, required this.icon, required this.label, this.ontap, this.color = ColorPalette.generalPrimaryColor})
      : super(key: key);
  final IconData icon;
  final String label;
  final Color color;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            SizedBox(width: 20),
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                    fontSize: 18, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
