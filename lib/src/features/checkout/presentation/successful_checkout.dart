import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/pages/home.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessfulCheckoutScreen extends StatefulWidget {
  const SuccessfulCheckoutScreen({super.key});

  @override
  State<SuccessfulCheckoutScreen> createState() => _SuccessfulCheckoutScreenState();
}

class _SuccessfulCheckoutScreenState extends State<SuccessfulCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppBarTitle(
          title: 'Спасибо за заказ!',
          color: AppColors.mainColor,
          fontSize: AppSizes.productOverviewTitle,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0).r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: ScreenUtil().screenWidth,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28).r,
                image: const DecorationImage(
                  image: AssetImage('assets/images/car_info/mercedes.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mercedes AMG GT S',
                  style: GoogleFonts.montserrat(
                    fontSize: AppSizes.title,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '557 л.с. 2021г.в. синий',
                  style: GoogleFonts.montserrat(
                    fontSize: AppSizes.title,
                    color: AppColors.textColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              'Номер вашего заказа :',
              style: GoogleFonts.montserrat(
                fontSize: AppSizes.productOverviewTitle,
                color: AppColors.mainColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              '№7728',
              style: GoogleFonts.montserrat(
                fontSize: AppSizes.productOverviewTitle,
                color: AppColors.mainColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Мы всяжемся с Вами в  ближайшее время для подтверждения бронирования!',
              style: GoogleFonts.montserrat(
                fontSize: 18.sp,
                color: AppColors.textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 40.h),
            MainButton(
              title: 'На главный экран',
              borderWidth: 2,
              height: 40,
              width: MediaQuery.of(context).size.width,
              borderColor: AppColors.mainColor,
              titleColor: AppColors.mainColor,
              bgColor: AppColors.secondColor,
              fontSize: AppSizes.mainButtonText,
              fontWeight: FontWeight.w400,
              onTap: () => Navigator.of(context).push(
                Platform.isIOS
                    ? CupertinoPageRoute(
                  builder: (_) => const HomePage(),
                )
                    : MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              ),
              borderRadius: 8,
              widget: null,
            ),
          ],
        ),
      ),
      floatingActionButton: AccountPageButton(
        onTap: () => Navigator.of(context).push(
          Platform.isIOS
              ? CupertinoPageRoute(
            builder: (_) => const AccountPage(),
          )
              : MaterialPageRoute(
            builder: (_) => const AccountPage(),
          ),
        ),
      ),
    );
  }
}
