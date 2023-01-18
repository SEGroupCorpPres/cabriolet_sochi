import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/sizes.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;

  const AppBarTitle({
    super.key,
    required this.title,
    required this.color,
    required this.fontSize,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}
