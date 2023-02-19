import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class AccountMenuButton extends StatelessWidget {
  final String title;
  final Widget widget;

  const AccountMenuButton({super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10).r,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: AppSizes.mainButtonText,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: 30.h,
                width: 100.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    widget,
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.labelColor,
          height: 2,
          indent: 18,
          endIndent: 20,
        ),
      ],
    );
  }
}