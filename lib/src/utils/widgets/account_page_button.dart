import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';
import 'main_button.dart';

class AccountPageButton extends StatelessWidget {
  final Function() onTap;
  const AccountPageButton({
    super.key, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 15,
              offset: const Offset(0, 0),
              spreadRadius: 2,
            ),
          ]
      ),
      child: MainButton(
        title: '',
        borderWidth: 0,
        height: 36,
        width: 36,
        borderColor: Colors.transparent,
        titleColor: Colors.transparent,
        bgColor: AppColors.secondColor,
        fontSize: 0,
        fontWeight: FontWeight.w600,
        onTap: onTap,
        borderRadius: 7,
        widget: const Icon(
          Icons.menu_outlined,
          color: AppColors.mainColor,
        ),
      ),
    );
  }
}
