import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/orders/presentation/confirm_order.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/widgets/account_page_button.dart';
import '../../../utils/widgets/less_car_info.dart';

class ProductOverview extends StatefulWidget {
  const ProductOverview({super.key});

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  final CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: AccountButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.adaptive.arrow_back,
        ),
        title: AppBarTitle(
          title: 'Mercedes AMG GT S',
          color: AppColors.mainColor,
          fontSize: AppSizes.productOverviewTitle,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20).r,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: ScreenUtil().screenWidth,
                        height: 250.h,
                      ),
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 250.h,
                          viewportFraction: 1,
                          autoPlay: false,
                          enlargeFactor: 1,
                        ),
                        carouselController: buttonCarouselController,
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index, int pageViewIndex) {
                          return Container(
                            width: ScreenUtil().screenWidth,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/car_info/mercedes.jpg'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          SizedBox(width: 10.w),
                          InkWell(
                            onTap: () => buttonCarouselController.previousPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            ),
                            child: CircleAvatar(
                              backgroundColor: AppColors.mainColor,
                              radius: 12.r,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 2.5).r,
                                child: SvgPicture.asset(
                                  'assets/icons/car_info/left_vector.svg',
                                  width: 13.r,
                                  height: 13.r,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () => buttonCarouselController.nextPage(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeIn,
                            ),
                            child: CircleAvatar(
                              backgroundColor: AppColors.mainColor,
                              radius: 12.r,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 2.5).r,
                                child: SvgPicture.asset(
                                  'assets/icons/car_info/right_vector.svg',
                                  width: 13.r,
                                  height: 13.r,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30).r,
                    child: SizedBox(
                      height: 200.h,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Flexible(
                                child: LessCarInfo(
                                  info: 'AMG GT S 2021 г.в.',
                                  image: 'calendar',
                                ),
                              ),
                              Flexible(
                                child: LessCarInfo(
                                  info: '2 места',
                                  image: 'people',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Flexible(
                                child: LessCarInfo(
                                  info: 'Двигатель 4.0 л,8 цилиндров Мощность 557 л.с., Сн. масса 1735 кг',
                                  image: 'car_engine',
                                ),
                              ),
                              Flexible(
                                child: LessCarInfo(
                                  info: 'Объем т. бака 65 л,Бензин Аи-98',
                                  image: 'gas',
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Flexible(
                                child: LessCarInfo(
                                  info: '7-ст. АКПП, задний привод',
                                  image: 'gear_shift',
                                ),
                              ),
                              Flexible(
                                child: LessCarInfo(
                                  info: 'Длина = 4544 мм, Ширина = 1939 мм, Высота = 1259 мм, Клиренс = 96 мм',
                                  image: 'maximize',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 20).r,
              padding: const EdgeInsets.all(13).r,
              height: 170.h,
              width: ScreenUtil().screenWidth,
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.only(
                  topRight: const Radius.circular(10).r,
                  bottomRight: const Radius.circular(10).r,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '60 000 ₽ в сутки',
                    style: GoogleFonts.montserrat(
                      fontSize: AppSizes.productOverviewTitle,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/car_info/bail.svg',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15.0).r,
                        child: SizedBox(
                          width: 130.w,
                          child: Text(
                            'Залог 100 000 ₽',
                            style: GoogleFonts.montserrat(
                              fontSize: AppSizes.fieldText,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Внимание! Для аренды кабриолета Mercedes GT имеются ограничения: минимальный допустимый возраст арендатора — 27 лет, минимальный допустимый стаж вождения арендатора — 5 лет ',
                    style: GoogleFonts.montserrat(
                      fontSize: AppSizes.mainLabel,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 20).r,
              child: MainButton(
                title: 'Забронировать авто'.toUpperCase(),
                borderWidth: 0,
                height: 35,
                width: MediaQuery.of(context).size.width,
                borderColor: Colors.transparent,
                titleColor: Colors.white,
                bgColor: AppColors.mainColor,
                fontSize: AppSizes.mainButtonText,
                fontWeight: FontWeight.w400,
                onTap: () => Navigator.of(context).push(
                  Platform.isIOS
                      ? CupertinoPageRoute(
                          builder: (_) => const ConfirmOrderPage(),
                        )
                      : MaterialPageRoute(
                          builder: (_) => const ConfirmOrderPage(),
                        ),
                ),
                borderRadius: 8,
                widget: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10).r,
              child: MainButton(
                title: 'Подать авто по адресу'.toUpperCase(),
                borderWidth: 2,
                height: 35,
                width: MediaQuery.of(context).size.width,
                borderColor: AppColors.mainColor,
                titleColor: AppColors.mainColor,
                bgColor: AppColors.secondColor,
                fontSize: AppSizes.mainButtonText,
                fontWeight: FontWeight.w400,
                onTap: () => Navigator.of(context).push(
                  Platform.isIOS
                      ? CupertinoPageRoute(
                          builder: (_) => const ConfirmOrderPage(),
                        )
                      : MaterialPageRoute(
                          builder: (_) => const ConfirmOrderPage(),
                        ),
                ),
                borderRadius: 8.r,
                widget: null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20).r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0).r,
                    child: Text(
                      'В комплектации:',
                      style: GoogleFonts.montserrat(
                        fontSize: AppSizes.mainButtonText,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    """ABS, ASR, ESP и др.
выхлопная система AMG Performance с возможностью настройки звука
электронный дифференциал повышенного трения
адаптивные амортизаторы
cистема экстренного торможения BAS
управляемые задние колеса
cистема контроля степени усталости водителя ATTENTION ASSIST
камера заднего вида, датчики парковки
электрические стеклоподъемники и зеркала
коричневый салон, мягкая перфорированная кожа ARTICO
AUX, Bluetooth, аудиосистема Burmester
электрический привод сидений с памятью, вентиляция, воздушный шарф
автосвет (ближний/дальний), поворотная оптика, ксенон, светодиодные фонари
двухзонный климат
датчик света, датчик дождя
автоматический круиз
объем багажника max=330 л""",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                      fontSize: AppSizes.productDesc,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0).r,
                    child: Text(
                      'Рекомендуем',
                      style: GoogleFonts.montserrat(
                        fontSize: AppSizes.mainButtonText,
                        color: AppColors.textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: ScreenUtil().screenWidth,
              padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20).r,
              height: 295.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).pushReplacement(
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (_) => const ProductOverview(),
                            )
                          : MaterialPageRoute(
                              builder: (_) => const ProductOverview(),
                            ),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, bottom: 40, left: 20).r,
                      height: 270.h,
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
                            width: ScreenUtil().screenWidth * 0.4,
                            height: 120.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15).r,
                              image: const DecorationImage(
                                image: AssetImage(
                                  'assets/images/home_list/aston_martin.jpg',
                                ),
                                fit: BoxFit.cover,
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
                                    height: 25,
                                    width: 150,
                                    decoration: const BoxDecoration(
                                      color: AppColors.mainColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
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
                  );
                },
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
