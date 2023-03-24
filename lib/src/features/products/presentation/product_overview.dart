import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/home_bloc.dart';
import 'package:cabriolet_sochi/src/features/orders/presentation/confirm_order.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/less_car_info.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductOverview extends StatefulWidget {
  final int? index;

  const ProductOverview({super.key, required this.index});

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  int? index;
  final CarouselController buttonCarouselController = CarouselController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    BlocProvider.of<HomeBloc>(context).add(GetDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is CarDataLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator.adaptive()),
          );
        } else if (state is CarDataLoaded) {
          final carModel = state.carData;
          return Scaffold(
            appBar: AppBar(
              leading: AccountButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.adaptive.arrow_back,
              ),
              title: AppBarTitle(
                title: carModel[index!].name!,
                color: AppColors.mainColor,
                fontSize: AppSizes.productOverviewTitle,
                fontWeight: FontWeight.w700,
              ),
            ),
            body: SingleChildScrollView(
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
                                enlargeFactor: 1,
                              ),
                              carouselController: buttonCarouselController,
                              itemCount: carModel[index!].images!.length,
                              itemBuilder: (BuildContext context, int indexImage, int pageViewIndex) {
                                return Container(
                                  width: ScreenUtil().screenWidth,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(carModel[index!].images![indexImage]!),
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
                            child: Wrap(
                              alignment: WrapAlignment.spaceAround,
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/car_info/calendar.svg',
                                            ),
                                            SizedBox(
                                              width: 135.w,
                                              child: LessCarInfo(
                                                info: carModel[index!].description,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/car_info/people.svg',
                                            ),
                                            LessCarInfo(
                                              info: '${carModel[index!].personCount} места',
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/car_info/car_engine.svg',
                                            ),
                                            SizedBox(
                                              width: 130.w,
                                              child: ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: carModel[index!].engineDescription!.length,
                                                itemBuilder: (context, item) {
                                                  return LessCarInfo(
                                                    info: carModel[index!].engineDescription![item]!,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/car_info/gas.svg',
                                            ),
                                            SizedBox(
                                              width: 130.w,
                                              child: ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: carModel[index!].fuelDescription!.length,
                                                itemBuilder: (context, item) {
                                                  return LessCarInfo(
                                                    info: carModel[index!].fuelDescription![item]!,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/car_info/gear_shift.svg',
                                            ),
                                            SizedBox(
                                              width: 130.w,
                                              child: ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: carModel[index!].transmissionDescription!.length,
                                                itemBuilder: (context, item) {
                                                  return LessCarInfo(
                                                    info: carModel[index!].transmissionDescription![item]!,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/car_info/maximize.svg',
                                            ),
                                            SizedBox(
                                              width: 130.w,
                                              child: ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: carModel[index!].dimensions!.length,
                                                itemBuilder: (context, item) {
                                                  return LessCarInfo(
                                                    info: carModel[index!].dimensions![item]!,
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
                    // constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(10).r,
                        bottomRight: const Radius.circular(10).r,
                      ),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        Text(
                          '${carModel[index!].rentalPrice!} ₽ в сутки',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.productOverviewTitle,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/car_info/bail.svg',
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15).r,
                              child: SizedBox(
                                width: 130.w,
                                child: Text(
                                  'Залог ${carModel[index!].deposite} ₽',
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
                          'Внимание! Для аренды кабриолета ${carModel[index!].name} имеются ограничения: минимальный допустимый возраст арендатора — 27 лет, минимальный допустимый стаж вождения арендатора — 5 лет ',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.mainLabel,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20.h),
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
                                builder: (_) => ConfirmOrderPage(
                                  carId: index,
                                ),
                              )
                            : MaterialPageRoute(
                                builder: (_) => ConfirmOrderPage(
                                  carId: index,
                                ),
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
                                builder: (_) => ConfirmOrderPage(
                                  carId: index,
                                ),
                              )
                            : MaterialPageRoute(
                                builder: (_) => ConfirmOrderPage(
                                  carId: index,
                                ),
                              ),
                      ),
                      borderRadius: 8.r,
                      widget: null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20).r,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15).r,
                          child: Text(
                            'В комплектации:',
                            style: GoogleFonts.montserrat(
                              fontSize: AppSizes.mainButtonText,
                              color: AppColors.textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: carModel[index!].package!.length,
                          itemBuilder: (BuildContext context, int item) {
                            return Text(
                              '・ ${carModel[index!].package![item]!}',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w400,
                                color: AppColors.textColor,
                                fontSize: AppSizes.productDesc + 1,
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15).r,
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
                    height: 329.h,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: carModel.length,
                      itemBuilder: (BuildContext context, int carIndex) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pushReplacement(
                            Platform.isIOS
                                ? CupertinoPageRoute(
                                    builder: (_) => ProductOverview(
                                      index: index,
                                    ),
                                  )
                                : MaterialPageRoute(
                                    builder: (_) => ProductOverview(
                                      index: index,
                                    ),
                                  ),
                          ),
                          child: Container(
                            // constraints: const BoxConstraints.expand(),
                            margin: const EdgeInsets.only(right: 10, bottom: 40, left: 20).r,
                            height: 280.h,
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
                              // direction: Axis.vertical,
                              children: [
                                Container(
                                  width: ScreenUtil().screenWidth * 0.48,
                                  height: 100.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15).r,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        carModel[carIndex].images![0].toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10).r,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                                        child: Text(
                                          '${carModel[carIndex].name!} ${carModel[carIndex].model}',
                                          style: GoogleFonts.montserrat(
                                            fontSize: AppSizes.productName,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                                        child: SizedBox(
                                          width: 156.w,
                                          child: Text(
                                            carModel[carIndex].description!,
                                            softWrap: true,
                                            style: GoogleFonts.montserrat(
                                              fontSize: AppSizes.productName,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                                        child: Text(
                                          carModel[carIndex].color!,
                                          style: GoogleFonts.montserrat(
                                            fontSize: AppSizes.productName,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2).r,
                                        child: Container(
                                          height: 25.h,
                                          width: 150.w,
                                          decoration: const BoxDecoration(
                                            color: AppColors.mainColor,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${carModel[carIndex].rentalPrice} ₽ в сутки',
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
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                                        child: Text(
                                          'залог ${carModel[carIndex].deposite} ₽',
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
        } else {
          return Container();
        }
      },
    );
  }
}
