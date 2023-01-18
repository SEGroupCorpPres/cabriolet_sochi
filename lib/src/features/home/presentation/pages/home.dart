import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/products/presentation/product_overview.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Page<void> page() => Platform.isIOS ? const CupertinoPage(child: HomePage()) : const MaterialPage<void>(child: HomePage());
  static Route<void> route() {
    return Platform.isIOS
        ? CupertinoPageRoute<void>(builder: (_) => const HomePage())
        : MaterialPageRoute<void>(
      builder: (_) => const HomePage(),
    );
  }
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(ScreenUtil().screenHeight);
  }

  @override
  Widget build(BuildContext context) {
    late final top = ScreenUtil().screenHeight < 800 ? 43 : 37;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: top.h),
              child: ResponsiveGridList(
                horizontalGridMargin: 20.w,
                horizontalGridSpacing: 30.w,
                verticalGridMargin: 0,
                verticalGridSpacing: 20.h,
                minItemWidth: 140.w,
                children: List.generate(
                  25,
                  (index) => GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (_) => const ProductOverview(),
                            )
                          : MaterialPageRoute(
                              builder: (_) => const ProductOverview(),
                            ),
                    ),
                    child: Container(
                      height: 210.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15).r,
                        color: AppColors.secondColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15).r,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/home_list/aston_martin.jpg',
                                ),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0).r,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1).r,
                                  child: Text(
                                    'Aston Martin DB11',
                                    style: GoogleFonts.montserrat(
                                      fontSize: AppSizes.productName,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1).r,
                                  child: Text(
                                    '510 л.с. 2019 г.в.',
                                    style: GoogleFonts.montserrat(
                                      fontSize: AppSizes.productName,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1).r,
                                  child: Text(
                                    'черный',
                                    style: GoogleFonts.montserrat(
                                      fontSize: AppSizes.productName,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2.0).r,
                                  child: Container(
                                    height: 20.h,
                                    width: 135.w,
                                    decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        bottomRight: Radius.circular(8),
                                      ).r,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '80 000 ₽ в сутки',
                                        style: GoogleFonts.montserrat(
                                          fontSize: AppSizes.fieldText,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1).r,
                                  child: Text(
                                    'залог 120 000 ₽',
                                    style: GoogleFonts.montserrat(
                                      fontSize: AppSizes.productName,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff6C6C6C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0).w,
                child: const FilterButton(),
              ),
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

class FilterButton extends StatefulWidget {
  const FilterButton({super.key});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  late bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: ScreenUtil().screenWidth - 40,
      padding: const EdgeInsets.only(left: 25, right: 25).r,
      height: isExpanded
          ? 50
          : ScreenUtil().screenHeight < 800
              ? ScreenUtil().screenHeight - 50
              : ScreenUtil().screenHeight - 100,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 500),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColor.withOpacity(0.7),
              blurRadius: 20,
              offset: const Offset(0, 20),
              spreadRadius: 2,
            ),
          ],
          color: AppColors.mainColor,
          borderRadius: BorderRadius.all(
            const Radius.circular(20).r,
          ),
          border: Border.all(color: AppColors.secondColor, width: 1.5.w)),
      child: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: SizedBox(
              height: 33.5.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0).r,
                    child: SvgPicture.asset(
                      'assets/icons/home_list/settings_line.svg',
                      height: 13.h,
                    ),
                  ),
                  Text(
                    isExpanded ? 'ФИЛЬТР И МАРКИ' : 'СБРОСИТЬ ФИЛЬТР',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      fontSize: AppSizes.productDesc,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const Text(
              '',
              style: TextStyle(
                fontSize: 0,
              ),
            ),
            secondChild: Column(
              children: <Widget>[
                SizedBox(
                  height: 244.h,
                  width: ScreenUtil().screenWidth - 40,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff626262),
                              borderRadius: BorderRadius.circular(11).r,
                            ),
                            width: 250.w,
                            height: 35.h,
                            padding: const EdgeInsets.symmetric(horizontal: 10).r,
                            margin: const EdgeInsets.symmetric(vertical: 1).r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/icons/home_list/filter/logo1.png'),
                                SizedBox(width: 30.w),
                                Text(
                                  'ASTON MARTIN'.toUpperCase(),
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    fontSize: AppSizes.productDesc,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Сортировать по:',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: AppSizes.mainButtonText,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff626262),
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/home_list/filter/price_tag.svg',
                                height: 30.h,
                              ),
                              SizedBox(width: 30.w),
                              Text(
                                'ЦЕНЕ'.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: AppSizes.productDesc,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff626262),
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/home_list/filter/calendar.svg',
                                height: 30.h,
                              ),
                              SizedBox(width: 30.w),
                              Text(
                                'Году выпуска'.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: AppSizes.productDesc,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff626262),
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/home_list/filter/car_engine.svg',
                                height: 30.h,
                              ),
                              SizedBox(width: 30.w),
                              Text(
                                'Мощности, л.с.'.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: AppSizes.productDesc,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff626262),
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/home_list/filter/people.svg',
                                height: 30.h,
                              ),
                              SizedBox(width: 30.w),
                              Text(
                                'КОл-ву мест'.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: AppSizes.productDesc,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff626262),
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/home_list/filter/spray_paint.svg',
                                height: 30.r,
                              ),
                              SizedBox(width: 30.w),
                              Text(
                                'Цвету авто'.toUpperCase(),
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: AppSizes.productDesc,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().screenHeight < 800 ? 50.h : 35.h),
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 3),
                    ],
                  ),
                  child: MainButton(
                    title: 'Применить',
                    borderWidth: 0,
                    height: 50,
                    width: 200,
                    borderColor: Colors.transparent,
                    titleColor: Colors.black,
                    bgColor: Colors.white,
                    fontSize: AppSizes.mainButtonText,
                    fontWeight: FontWeight.w600,
                    onTap: () {},
                    borderRadius: 8,
                    widget: null,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: Duration(milliseconds: isExpanded ? 500 : 2000),
            reverseDuration: Duration.zero,
            sizeCurve: Curves.fastLinearToSlowEaseIn,
          ),
        ],
      ),
    );
  }
}
