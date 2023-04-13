import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class MainTextFormField extends StatelessWidget {
  const MainTextFormField({
    super.key,
    required this.horizontalPadding,
    required this.label,
    required this.labelFontSize,
    required this.labelColor,
    required this.marginContainer,
    required this.width,
    required this.height,
    this.size,
    required this.bgColor,
    required this.borderR,
    this.onTap,
    required this.keyboardType,
    required this.border,
    required this.contentPaddingHorizontal,
    this.icon,
    this.hintText,
    required this.textEditingController,
    required this.onChanged,
    this.onPressed,
    required this.obscureText,
    this.isPassword = false,
    this.inputFormatters,
    this.visible = false,
    this.errorText = '',
    this.focusedBorderColor,
    this.enableBorderColor,
    this.errorBorderColor,
  });

  final double horizontalPadding;
  final String label;
  final double labelFontSize;
  final Color labelColor;
  final double marginContainer;
  final double width;
  final double height;
  final double? size;
  final Color bgColor;
  final double borderR;
  final void Function()? onTap;
  final TextInputType keyboardType;
  final InputBorder border;
  final double contentPaddingHorizontal;
  final String? hintText;
  final String? icon;
  final bool obscureText;
  final TextEditingController textEditingController;
  final Function(String?) onChanged;
  final Function()? onPressed;
  final bool? isPassword;
  final List<TextInputFormatter>? inputFormatters;
  final bool? visible;
  final String? errorText;
  final Color? focusedBorderColor, enableBorderColor, errorBorderColor;

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
              margin: EdgeInsets.only(top: marginContainer).r,
              width: width.w,
              height: height.h,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(borderR).r,
              ),
              child: TextFormField(
                onTap: onTap,
                controller: textEditingController,
                obscureText: obscureText,
                style: GoogleFonts.montserrat(),
                keyboardType: keyboardType,
                obscuringCharacter: '*',
                inputFormatters: inputFormatters,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderR).r,
                    borderSide: BorderSide(
                      color: focusedBorderColor ?? AppColors.secondColor,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderR).r,
                    borderSide: BorderSide(
                      color: enableBorderColor ?? AppColors.secondColor,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderR).r,
                    borderSide: BorderSide(
                      color: errorBorderColor ?? AppColors.secondColor,
                    ),
                  ),
                  border: border,
                  contentPadding: EdgeInsets.symmetric(horizontal: contentPaddingHorizontal, vertical: 5).r,
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
                          child: GestureDetector(
                            onTap: onPressed,
                            child: SvgPicture.asset(
                              icon!,
                              color: Colors.grey.withOpacity(0.5),
                              height: size!.h,
                              width: size!.w,
                            ),
                          ),
                        ),
                  suffixIconConstraints: isPassword! ? const BoxConstraints.expand(width: 25, height: 25).r : const BoxConstraints.expand(width: 20, height: 20).r,
                ),
              ),
            ),
            Row(
              children: [
                Visibility(
                  visible: visible ?? false,
                  child: Text(
                    errorText ?? '',
                    style: GoogleFonts.montserrat(
                      color: Colors.red,
                      fontSize: 10
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
