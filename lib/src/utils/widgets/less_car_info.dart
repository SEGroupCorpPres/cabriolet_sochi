import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class LessCarInfo extends StatelessWidget {
  final dynamic info;

  const LessCarInfo({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0).r,
      child: Text(
        info.toString(),
        style: GoogleFonts.montserrat(
          fontSize: AppSizes.productDesc,
          fontWeight: FontWeight.w400,
          color: AppColors.textColor,
        ),
        textAlign: TextAlign.start,
        softWrap: true,
      ),
    );
  }
}
