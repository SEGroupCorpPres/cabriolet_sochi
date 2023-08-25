import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/filter/filter_bloc.dart';
import 'package:cabriolet_sochi/src/features/home/data/models/filter_items.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/widgets/filter_items.dart';
import 'package:cabriolet_sochi/src/utils/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterButton extends StatefulWidget {
  final bool isExpanded;
  const FilterButton({super.key, required this.isExpanded});

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  late List<String?>? filterName = [];
  late String? orderName = '';
  late bool isSelect = false;
  int? _selectedValueIndex;
  List<FilterItems> filterItems = FilterItems.filterItems;
  late bool isExpanded = widget.isExpanded;
  @override
  Widget build(BuildContext context) {
    var selectingFilterValue = <String>[];
    var orderValue = '';
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        if (state is LoadingFilter) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is LoadedFilter) {
          final filterState = state.filterBloc.filter;
          return AnimatedContainer(
            width: ScreenUtil().screenWidth - 40,
            padding: const EdgeInsets.only(left: 25, right: 25).r,
            height: isExpanded
                ? 50
                : ScreenUtil().screenHeight < 800
                ? ScreenUtil().screenHeight - 50
                : ScreenUtil().screenHeight - 90,
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
                    // for (final int item in filterItems as Iterable<int>) {
                    //   filterItems[item].isSelected = false;
                    // }
                    setState(() {
                      for (final element in filterItems) {
                        element.isSelected = false;
                      }
                      isExpanded = !isExpanded;
                      _selectedValueIndex = null;
                      selectingFilterValue = [];
                      orderValue = '';
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
                        child: FilterItemsList(
                          selectingFilterValue: selectingFilterValue,
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
                                setState(() {
                                  _selectedValueIndex = 0;
                                  orderValue = 'rentalPrice';
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
                                setState(() {
                                  _selectedValueIndex = 1;
                                  orderValue = 'year';
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
                                setState(() {
                                  _selectedValueIndex = 2;
                                  orderValue = 'output';
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
                                setState(() {
                                  _selectedValueIndex = 3;
                                  orderValue = 'personCount';
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
                                      'Кол-ву мест'.toUpperCase(),
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
                                setState(() {
                                  _selectedValueIndex = 4;
                                  orderValue = 'color';
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
                          height: 40,
                          width: 200,
                          borderColor: Colors.transparent,
                          titleColor: Colors.black,
                          bgColor: Colors.white,
                          fontSize: AppSizes.mainButtonText,
                          fontWeight: FontWeight.w600,
                          onTap: () async {
                            final filters = filterState
                                .where(
                                  (element) => element.value,
                            )
                                .map(
                                  (e) => e.filterItems.name,
                            )
                                .toList();
                            context.read<FilterBloc>().add(FilterAndOrdersChangesEvent(filters, ''));
                            setState(() {
                              isExpanded = !isExpanded;
                              orderName = orderValue;
                              filterName = selectingFilterValue;
                              // _orderValue(orderName);
                              // _filterValue(filterName);
                              if (kDebugMode) {
                                print('main button');
                                print(orderValue);
                                print(selectingFilterValue);
                                print(orderName);
                                print(filterName);
                              }
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
        } else if (state is FilterError) {
          return Center(child: Text(state.error));
        } else {
          return Container();
        }
      },
    );
  }
}
