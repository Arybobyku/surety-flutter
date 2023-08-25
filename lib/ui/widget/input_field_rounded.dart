import 'package:flutter/material.dart';
import 'package:surety/helper/color_palette.dart';

class InputFieldRounded extends StatelessWidget {
  final String hint;
  final String? initialValue;
  final String? label;
  final Widget? icon;
  final String? title;
  final ValueChanged<String> onChange;
  final Widget? suffixIcon;
  final bool secureText;
  final TextInputType keyboardType;
  final bool enable;
  final int minLines;
  final String? errortext;
  final FormFieldValidator? validatorCheck;
  final TextEditingController? controller;

  const InputFieldRounded({
    Key? key,
    required this.hint,
    this.label,
    this.icon,
    this.title,
    required this.onChange,
    this.validatorCheck,
    this.initialValue,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.errortext,
    this.secureText = false,
    this.minLines = 1,
    this.enable = true,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.0),
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              color: enable ? Colors.white : ColorPalette.generalSoftGrey,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: TextFormField(
            initialValue: initialValue,
            validator: validatorCheck,
            onChanged: onChange,
            obscureText: secureText,
            cursorColor: ColorPalette.generalPrimaryColor,
            keyboardType: keyboardType,
            controller: controller,
            enabled: enable,
            minLines: minLines,
            maxLines: secureText ? 1 : 10,
            decoration: InputDecoration(
              errorText: errortext,
              filled: false,
              hoverColor: ColorPalette.generalPrimaryColor,
              labelText: label,
              hintText: hint,
              icon: icon,
              iconColor: Colors.grey,
              floatingLabelStyle:
                  TextStyle(color: ColorPalette.generalPrimaryColor),
              suffixIcon: suffixIcon,
              focusColor: ColorPalette.generalPrimaryColor,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
