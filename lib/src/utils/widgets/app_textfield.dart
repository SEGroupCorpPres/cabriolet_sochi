import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.autofocus = false,
    this.controller,
    this.onChanged,
    this.focusNode,
    this.inputType,
    this.fontSize = 15.0,
    this.textAlign = TextAlign.start,
    this.maxLength,
  }) : super(key: key);
  final bool autofocus;
  final TextEditingController? controller;
  final Function(String txt)? onChanged;
  final FocusNode? focusNode;
  final TextInputType? inputType;
  final double fontSize;
  final TextAlign textAlign;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          keyboardType: inputType,
          autofocus: autofocus,
          onChanged: onChanged,
          focusNode: focusNode,
          textAlign: textAlign,
          maxLength: maxLength,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(fontSize: fontSize),
          decoration: InputDecoration(
            filled: true,
            focusColor: AppColors.mainColor,
            hoverColor: AppColors.mainColor,

            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(borderRadius),
            //   borderSide: BorderSide.none,
            // ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.r,
              vertical: 10.r,
            ),
            // focusedBorder: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(borderRadius),
            //   borderSide: BorderSide(
            //     width: 1.8,
            //     color: Theme.of(context).primaryColor,
            //   ),
            // ),
          ),
        ),
      ],
    );
  }
}
