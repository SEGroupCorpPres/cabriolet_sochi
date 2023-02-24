import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/home_bloc.dart';
import 'package:cabriolet_sochi/src/features/home/data/models/car_model.dart';
import 'package:cabriolet_sochi/src/features/products/presentation/product_overview.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late List<CarModel> carFilterName = [];
  late List<String> filterName = [];
  late String orderName = '';
  late bool isExpanded = true;
  late bool isSelect = false;
  int? _selectedValueIndex;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(GetDataEvent());
    print(ScreenUtil().screenHeight);
  }

  Future<void> _filterValue(List<String> filterValue) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('filterValue', filterValue);
    // print(object)
  }

  Future<void> _orderValue(String orderValue) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString('orderValue', orderValue);
    // print(object)
  }

  @override
  Widget build(BuildContext context) {
    late final top = ScreenUtil().screenHeight < 800 ? 43 : 37;
    return Scaffold(
      key: scaffoldKey,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is CarDataLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is CarDataLoaded) {
            final carModel = state.carData;
            Future.delayed(Duration.zero, () {
              carFilterName = state.carData;
            });
            return SafeArea(
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
                        carModel.length,
                        (index) => GestureDetector(
                          onTap: () => Navigator.of(context).push(
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
                            height: 222.h,
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
                                  height: 99.h,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15).r,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        carModel[index].images![0].toString(),
                                      ),
                                      fit: BoxFit.fitWidth,
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
                                          '${carModel[index].name!}  ${carModel[index].model!}',
                                          style: GoogleFonts.montserrat(
                                            fontSize: AppSizes.productName,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                                        child: Text(
                                          carModel[index].description!,
                                          style: GoogleFonts.montserrat(
                                            fontSize: AppSizes.productDesc,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                                        child: Text(
                                          carModel[index].color!,
                                          style: GoogleFonts.montserrat(
                                            fontSize: AppSizes.productName,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2).r,
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
                                              '${carModel[index].rentalPrice!} ₽ в сутки',
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
                                          'залог ${carModel[index].deposit!} ₽',
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
                      padding: const EdgeInsets.symmetric(horizontal: 17).w,
                      child: _filterButton(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: isExpanded
          ? AccountPageButton(
              onTap: () => Navigator.of(context).push(
                Platform.isIOS
                    ? CupertinoPageRoute(
                        builder: (_) => const AccountPage(),
                      )
                    : MaterialPageRoute(
                        builder: (_) => const AccountPage(),
                      ),
              ),
            )
          : Container(),
    );
  }

  Widget _filterButton() {
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
        border: Border.all(color: AppColors.secondColor, width: 1.5.w),
      ),
      child: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
                // _isExpanded();
              });
            },
            child: SizedBox(
              height: 33.5.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8).r,
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
              children: [
                SizedBox(
                  height: 244.h,
                  width: ScreenUtil().screenWidth - 40,
                  child: ListView.builder(
                    itemCount: carFilterName.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          isSelect = !isSelect;
                          filterName.add(carFilterName[index].name!);
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelect ? const Color(0xff626262) : Colors.transparent,
                          borderRadius: BorderRadius.circular(11).r,
                        ),
                        width: 250.w,
                        height: 35.h,
                        padding: const EdgeInsets.symmetric(horizontal: 10).r,
                        margin: const EdgeInsets.symmetric(vertical: 1).r,
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: carFilterName[index].carLogo!,
                              fit: BoxFit.contain,
                              width: 45.w,
                              height: 30.h,
                            ),
                            SizedBox(width: 30.w),
                            Text(
                              carFilterName[index].name!.toUpperCase(),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          setState(() async {
                            _selectedValueIndex = 0;
                            orderName = 'rentalPrice';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedValueIndex == 0 ? const Color(0xff626262) : Colors.transparent,
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
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
                        onTap: () {
                          setState(() async {
                            _selectedValueIndex = 1;
                            orderName = 'year';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedValueIndex == 1 ? const Color(0xff626262) : Colors.transparent,
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
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
                        onTap: () {
                          setState(() async {
                            _selectedValueIndex = 2;
                            orderName = 'output';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedValueIndex == 2 ? const Color(0xff626262) : Colors.transparent,
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
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
                        onTap: () {
                          setState(() async {
                            _selectedValueIndex = 3;
                            orderName = 'personCount';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedValueIndex == 3 ? const Color(0xff626262) : Colors.transparent,
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
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
                        onTap: () {
                          setState(() async {
                            _selectedValueIndex = 4;
                            orderName = 'color';
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _selectedValueIndex == 4 ? const Color(0xff626262) : Colors.transparent,
                            borderRadius: BorderRadius.circular(11).r,
                          ),
                          width: 250.w,
                          height: 35.h,
                          padding: const EdgeInsets.symmetric(horizontal: 10).r,
                          margin: const EdgeInsets.symmetric(vertical: 1).r,
                          child: Row(
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
                DecoratedBox(
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
                    onTap: () {
                      setState(() async {
                        isExpanded = !isExpanded;
                        await _orderValue(orderName);
                        await _filterValue(filterName);
                        // _isExpanded();
                      });
                    },
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
