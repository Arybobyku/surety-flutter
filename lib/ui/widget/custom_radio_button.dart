import 'package:flutter/material.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/model/radio_value_model.dart';

class CustomRadioButton extends StatelessWidget {
  const CustomRadioButton({Key? key, this.selectedValue,required this.onChanged,required this.optionValue})
      : super(key: key);
  final selectedValue;
  final Function(String value) onChanged;
  final List<RadioValueModel> optionValue;

  //1=off; 2=normal; 3=rusak; 4=standby; 5= Tidak Normal
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: optionValue.length,
          itemBuilder: (context,index){
            var value = optionValue[index];
            return  SizedBox(
              height: 35,
              child: Row(
                children: [
                  Radio(
                    groupValue: selectedValue,
                    value: value.kode??"",
                    activeColor: ColorPalette.generalPrimaryColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity(horizontal: -4),
                    onChanged: (value) {
                      onChanged(value.toString());
                    },
                  ),
                  SizedBox(width: 8),
                  Row(
                    children: [
                      // Text(
                      //   ??"",
                      //   style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                      // ),
                      Text(
                        "${value.name}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
