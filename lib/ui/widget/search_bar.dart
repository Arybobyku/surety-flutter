import 'package:flutter/material.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/helper/constants.dart';
import 'package:surety/ui/widget/input_field_rounded.dart';

class SearchBar extends StatelessWidget {
  const SearchBar(
      {Key? key, this.onTapSearch, this.enable = true, this.onChanged,this.onEditingCompleted,this.title = "Cari Keramik",this.onSubmit})
      : super(key: key);
  final Function()? onTapSearch;
  final Function()? onEditingCompleted;
  final Function(String)? onChanged;
  final Function(String)? onSubmit;
  final bool enable;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapSearch,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: kRoundedContainer.copyWith(
          border: Border.all(
              width: 0, color: ColorPalette.generalPrimaryColor),
          borderRadius: BorderRadius.circular(30),
          color: ColorPalette.generalBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: ColorPalette.generalPrimaryColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.search, color: ColorPalette.generalPrimaryColor,),
            SizedBox(width: 10,),
            Expanded(
              child: TextField(
                maxLines: 1,
                minLines: 1,
                enabled: enable,
                onChanged:onChanged,
                onEditingComplete: onEditingCompleted,
                onSubmitted: onSubmit,
                decoration: InputDecoration(
                  filled: false,
                  isDense: true,
                  hoverColor: ColorPalette.generalPrimaryColor,
                  hintText: title,
                  hintStyle: TextStyle(
                      color: ColorPalette.generalPrimaryColor
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  counterText: null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
