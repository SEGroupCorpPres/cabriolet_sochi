import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MainTextFormField extends StatelessWidget {
  final double horizontalPadding;
  final String label;
  final double labelFontSize;
  final Color labelColor;
  final double marginContainer;
  final double width;
  final double height;
  final Color bgColor;
  final double borderR;
  final TextInputType keyboardType;
  final InputBorder border;
  final double contentPaddingHorizontal;
  final String? hintText;
  final String? icon;
  final TextEditingController textEditingController;
  final String? Function(String?)? validator;
  final Function(String?)? onSaved;
  final Function(String?) onChanged;

  const MainTextFormField({
    super.key,
    required this.horizontalPadding,
    required this.label,
    required this.labelFontSize,
    required this.labelColor,
    required this.marginContainer,
    required this.width,
    required this.height,
    required this.bgColor,
    required this.borderR,
    required this.keyboardType,
    required this.border,
    required this.contentPaddingHorizontal,
    this.icon,
    this.hintText,
    required this.textEditingController,
    required this.validator,
    this.onSaved,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: labelFontSize,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: marginContainer).r,
              width: width.w,
              height: height.h,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderR).r,
              ),
              child: TextFormField(
                controller: textEditingController,
                style: GoogleFonts.montserrat(),
                keyboardType: keyboardType,
                decoration: InputDecoration(
                  border: border,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: contentPaddingHorizontal,
                  ).r,
                  hintText: hintText,
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: AppSizes.fieldText,
                    color: AppColors.labelColor.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: icon == null
                      ? Container()
                      : Padding(
                          padding: EdgeInsetsDirectional.only(end: 5.w, start: 0.w),
                          child: SvgPicture.asset(
                            icon!,
                            color: Colors.grey.withOpacity(0.5),
                            height: 20.r,
                            width: 20.r,
                          ),
                        ),
                  suffixIconConstraints: const BoxConstraints.expand(width: 20, height: 20).r,
                ),
                validator: validator,
                onSaved: onSaved,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
