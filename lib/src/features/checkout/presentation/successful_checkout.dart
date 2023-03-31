import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/home_bloc.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/pages/home.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessfulCheckoutScreen extends StatefulWidget {
  const SuccessfulCheckoutScreen({super.key, required this.orderId, required this.index});

  final int? orderId;
  final int? index;

  @override
  State<SuccessfulCheckoutScreen> createState() => _SuccessfulCheckoutScreenState();
}

class _SuccessfulCheckoutScreenState extends State<SuccessfulCheckoutScreen> {
  int? orderId;
  int? index;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    index = widget.index;
    orderId = widget.orderId;
  }

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
      body: WillPopScope(
        onWillPop: () async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Вы хотите выйти из приложения?',
                  style: GoogleFonts.montserrat(
                    fontSize: AppSizes.productName,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff6C6C6C),
                  ),
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  TextButton(
                    onPressed: () => Platform.isAndroid
                        ? SystemNavigator.pop()
                        : Platform.isIOS
                            ? exit(0)
                            : null,
                    child: Text(
                      'Да',
                      style: GoogleFonts.montserrat(
                        fontSize: AppSizes.productName,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff6C6C6C),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(
                      'Нет',
                      style: GoogleFonts.montserrat(
                        fontSize: AppSizes.productName,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff6C6C6C),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is CarDataLoading) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (state is CarDataLoaded) {
              final carModel = state.carData;
              return Padding(
                padding: const EdgeInsets.all(20).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: 200.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28).r,
                        image: DecorationImage(
                          image: NetworkImage(carModel[index!].images![0].toString()),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${carModel[index!].name} ${carModel[index!].model}',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.title,
                            color: AppColors.textColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '${carModel[index!].description} ${carModel[index!].color}',
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
                      '№$orderId',
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
                      onTap: () => Navigator.of(context).pushReplacement(
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
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: AccountPageButton(
        onTap: () => Navigator.of(context).pushReplacement(
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
