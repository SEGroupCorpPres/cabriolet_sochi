import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class LessCarInfo extends StatelessWidget {
  final String info;
  final String image;

  const LessCarInfo({
    super.key,
    required this.info,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          'assets/icons/car_info/$image.svg',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0).r,
          child: SizedBox(
            width: 130.w,
            child: Text(
              info,
              style: GoogleFonts.montserrat(
                fontSize: AppSizes.productDesc,
                fontWeight: FontWeight.w400,
                color: AppColors.textColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
