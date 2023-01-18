import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MainButton extends StatelessWidget {
  final String title;
  final double fontSize;
  final double borderWidth;
  final double height;
  final double width;
  final double borderRadius;
  final Color borderColor;
  final Color titleColor;
  final Color bgColor;
  final FontWeight fontWeight;
  final void Function() onTap;
  final Widget? widget;

  const MainButton({
    super.key,
    required this.title,
    required this.borderWidth,
    required this.height,
    required this.width,
    required this.borderColor,
    required this.titleColor,
    required this.bgColor,
    required this.fontSize,
    required this.fontWeight,
    required this.onTap,
    required this.borderRadius,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: borderColor,
            width: borderWidth.sm,
          ),
          borderRadius: BorderRadius.circular(borderRadius).r,
          color: bgColor,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget ?? Container(),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: fontSize,
                color: titleColor,
                fontWeight: fontWeight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
