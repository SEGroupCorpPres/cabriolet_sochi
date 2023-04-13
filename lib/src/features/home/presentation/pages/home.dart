import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/home_bloc.dart';
import 'package:cabriolet_sochi/src/features/home/data/models/car_model.dart';
import 'package:cabriolet_sochi/src/features/home/data/models/filter_items.dart';
import 'package:cabriolet_sochi/src/features/home/domain/repositories/car_repository.dart';
import 'package:cabriolet_sochi/src/features/products/presentation/product_overview.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  late List<CarModel> carFilterModel = [];
  List<CarModel> carsModel = <CarModel>[];
  late List<String?>? filterName = [];
  late String? orderName = '';
  late bool isExpanded = true;
  late bool isSelect = false;
  int? _selectedValueIndex;
  List<FilterItems> filterItems = FilterItems.filterItems;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CarRepository carRepository = CarRepository();

  // List<String> selectedFilters = [];

  @override
  void initState() {
    // ignore: flutter_style_todos
    // TODO: implement initState
    super.initState();

    BlocProvider.of<HomeBloc>(context).add(GetDataEvent());
    BlocProvider.of<HomeBloc>(context).add(LoadFilterButtonHeight());
    BlocProvider.of<HomeBloc>(context).add(LoadFilter());
    if (kDebugMode) {
      print(ScreenUtil().screenHeight);
    }
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    BlocProvider.of<HomeBloc>(context).add(GetDataEvent());
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    late final top = ScreenUtil().screenHeight < 800 ? 43 : 37;
    return Scaffold(
      key: scaffoldKey,
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
        child: SafeArea(
          child: Stack(
            children: [
              BlocConsumer<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is CarDataLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is CarDataLoaded) {
                    carsModel = state.carData;
                    return _homeList(carsModel);
                  } else if (state is CarDataError) {
                    return Center(child: Text(state.error));
                  } else {
                    if (kDebugMode) {
                      print('Something error');
                    }
                    return Container();
                  }
                },
                listener: (context, state) {},
              ),
              // BlocBuilder<HomeBloc, HomeState>(
              //   builder: (context, state) {
            Positioned(
                    top: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 17).w,
                      child: _filterButton(),
                    ),
                  )
              //   },
              // ),
            ],
          ),
        ),
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

  ResponsiveGridList _homeList(List<CarModel> carsModel) {
    return ResponsiveGridList(
      horizontalGridMargin: 20.w,
      horizontalGridSpacing: 30.w,
      verticalGridMargin: 0,
      verticalGridSpacing: 20.h,
      minItemWidth: 140.w,
      children: List.generate(
        carsModel.length,
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
            constraints: const BoxConstraints.expand(),
            // height: 270.h,
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
            child: Wrap(
              children: [
                Container(
                  width: double.infinity,
                  height: 99.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15).r,
                    image: DecorationImage(
                      image: NetworkImage(
                        carsModel[index].images![0].toString(),
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
                          '${carsModel[index].name!}  ${carsModel[index].model!}',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.productName,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                        child: Text(
                          '${carsModel[index].output!} л.с. ${carsModel[index].year} г.в.',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.productDesc,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                        child: Text(
                          carsModel[index].color!,
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
                              '${carsModel[index].rentalPrice!} ₽ в сутки',
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
                          'залог ${carsModel[index].deposite} ₽',
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
    );
  }

  Widget _filterButton() {
    // Future<void> _filterValue(List<String> filterValue) async {
    //   final preferences = await SharedPreferences.getInstance();
    //   await preferences.setStringList('filterValue', filterValue);
    //   if (kDebugMode) {
    //     print(filterValue);
    //   }
    // }
    //
    // Future<void> _orderValue(String orderValue) async {
    //   final preferences = await SharedPreferences.getInstance();
    //   await preferences.setString('orderValue', orderValue);
    //   if (kDebugMode) {
    //     print(orderValue);
    //   }
    // }

    var selectingFilterValue = <String>[];
    var orderValue = '';
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is LoadingFilter) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        if (state is LoadedFilter) {
          final filterState = state.filterBloc.filter;
          return BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is LoadedFilterButtonHeight) {
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
                          context.read<HomeBloc>().add(UpdatedFilterButtonHeight(isExpanded: !state.isExpended));
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
                              child: _filterItems(
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
                                  context.read<HomeBloc>().add(UpdatedFilterButtonHeight(isExpanded: !state.isExpended));
                                  context.read<HomeBloc>().add(FilterAndOrdersChangesEvent(filters, ''));
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
              } else if (state is CarDataError) {
                return Center(child: Text(state.error));
              } else {
                return Container();
              }
            },
          );
        } else if (state is CarDataError) {
          return Center(child: Text(state.error));
        } else {
          return Container();
        }
      },
    );
  }

  Widget _filterItems({required List<String?>? selectingFilterValue}) {
    return ListView.builder(
      itemCount: filterItems.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          setState(() {
            // context.read<HomeBloc>().add(UpdatedFilter(filter: filter[index].copyWith(value: !filter[index].value)));
            filterItems[index].isSelected = !filterItems[index].isSelected;
            if (filterItems[index].isSelected) {
              selectingFilterValue!.add(
                filterItems[index].name,
              );
            } else if (filterItems[index].isSelected == false) {
              selectingFilterValue?.removeWhere((element) => element == filterItems[index].name);
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: filterItems[index].isSelected ? const Color(0xff626262) : Colors.transparent,
            borderRadius: BorderRadius.circular(11).r,
          ),
          width: 250.w,
          height: 35.h,
          padding: const EdgeInsets.symmetric(horizontal: 10).r,
          margin: const EdgeInsets.symmetric(vertical: 1).r,
          child: Row(
            children: [
              Image.asset(
                filterItems[index].imgSrc,
                fit: BoxFit.contain,
                width: 45.w,
                height: 30.h,
              ),
              SizedBox(width: 30.w),
              Text(
                filterItems[index].name.toUpperCase(),
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
    );
  }
}

// class FilterItem extends StatefulWidget {
//   List<String?>? selectingFilterValue;
//
//   FilterItem({super.key, required this.selectingFilterValue});
//
//   @override
//   State<FilterItem> createState() => _FilterItemState();
// }
//
// class _FilterItemState extends State<FilterItem> {
//   @override
//   void initState() {
//     // ignore: flutter_style_todos
//     // TODO: implement initState
//     super.initState();
//     selectingFilterValue = widget.selectingFilterValue;
//   }
//
//   List<String?>? selectingFilterValue = <String>[];
//   List<FilterItems> filterItems = FilterItems.filterItems;
//
//   @override
//   Widget build(BuildContext context) {
//     // return BlocBuilder<HomeBloc, HomeState>(
//     //   builder: (context, state) {
//     //     if (state is LoadingFilter) {
//     //       return const Center(
//     //         child: CircularProgressIndicator.adaptive(),
//     //       );
//     //     } else if (state is LoadedFilter) {
//     //       final filter = state.filterBloc.filter;
//
//     // } else {
//     //   return Container();
//     //     }
//     //   },
//     // );
//   }
// }
// // floatingActionButton: BlocBuilder<HomeBloc, HomeState>(
// //   builder: (context, state) {
// //     if (state is LoadingFilterButtonHeight) {
// //       return const Center(child: CircularProgressIndicator.adaptive(),);
// //     }
// //     if (state is LoadedFilterButtonHeight) {
// //       return !state.isExpended
// //           ? AccountPageButton(
// //               onTap: () => Navigator.of(context).push(
// //                 Platform.isIOS
// //                     ? CupertinoPageRoute(
// //                         builder: (_) => const AccountPage(),
// //                       )
// //                     : MaterialPageRoute(
// //                         builder: (_) => const AccountPage(),
// //                       ),
// //               ),
// //             )
// //           : Container(
// //               width: 30,
// //               height: 30,
// //               color: Colors.amber,
// //             );
// //     } else if (state is CarDataError) {
// //       return Center(child: Text(state.error));
// //     } else {
// //       return Container(
// //         width: 30,
// //         height: 30,
// //         color: Colors.blue,
// //       );
// //     }
// //   },
// // ),

// class FilterButton extends StatefulWidget {
//   FilterButton({Key? key}) : super(key: key);
//
//   @override
//   State<FilterButton> createState() => _FilterButtonState();
// }
//
// class _FilterButtonState extends State<FilterButton> {
//   int? _selectedValueIndex;
//
//   List<String> selectingFilterValue = <String>[];
//
//   String orderValue = '';
//
//   String orderName = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeBloc, HomeState>(
//       builder: (context, state) {
//         if (state is LoadingFilter) {
//           return const Center(
//             child: CircularProgressIndicator.adaptive(),
//           );
//         }
//         if (state is LoadedFilter) {
//           final filterState = state.filterBloc.filter;
//           return BlocBuilder<HomeBloc, HomeState>(
//             builder: (context, state) {
//               if (state is LoadedFilterButtonHeight) {
//                 return AnimatedContainer(
//                   width: ScreenUtil().screenWidth - 40,
//                   padding: const EdgeInsets.only(left: 25, right: 25).r,
//                   height: state.isExpended
//                       ? 50
//                       : ScreenUtil().screenHeight < 800
//                           ? ScreenUtil().screenHeight - 50
//                           : ScreenUtil().screenHeight - 100,
//                   curve: Curves.fastLinearToSlowEaseIn,
//                   duration: const Duration(milliseconds: 500),
//                   decoration: BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: AppColors.mainColor.withOpacity(0.7),
//                         blurRadius: 20,
//                         offset: const Offset(0, 20),
//                         spreadRadius: 2,
//                       ),
//                     ],
//                     color: AppColors.mainColor,
//                     borderRadius: BorderRadius.all(
//                       const Radius.circular(20).r,
//                     ),
//                     border: Border.all(color: AppColors.secondColor, width: 1.5.w),
//                   ),
//                   child: Column(
//                     children: [
//                       InkWell(
//                         highlightColor: Colors.transparent,
//                         splashColor: Colors.transparent,
//                         onTap: () {
//                           context.read<HomeBloc>().add(UpdatedFilterButtonHeight(isExpanded: !state.isExpended));
//                           _selectedValueIndex = null;
//                           selectingFilterValue = [];
//                           orderName = '';
//                         },
//                         child: SizedBox(
//                           height: 33.5.h,
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(right: 8).r,
//                                 child: SvgPicture.asset(
//                                   'assets/icons/home_list/settings_line.svg',
//                                   height: 13.h,
//                                 ),
//                               ),
//                               Text(
//                                 state.isExpended ? 'ФИЛЬТР И МАРКИ' : 'СБРОСИТЬ ФИЛЬТР',
//                                 style: GoogleFonts.montserrat(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: AppSizes.productDesc,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                       AnimatedCrossFade(
//                         firstChild: const Text(
//                           '',
//                           style: TextStyle(
//                             fontSize: 0,
//                           ),
//                         ),
//                         secondChild: Column(
//                           children: [
//                             SizedBox(
//                               height: 244.h,
//                               width: ScreenUtil().screenWidth - 40,
//                               child: FilterItem(
//                                 selectingFilterValue: selectingFilterValue,
//                               ),
//                             ),
//                             SizedBox(height: 25.h),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   'Сортировать по:',
//                                   style: GoogleFonts.montserrat(
//                                     color: Colors.white,
//                                     fontSize: AppSizes.mainButtonText,
//                                     fontWeight: FontWeight.w400,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(height: 10.h),
//                             SizedBox(
//                               width: MediaQuery.of(context).size.width,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   GestureDetector(
//                                     onTap: () {
//                                       // setState(() {
//                                       _selectedValueIndex = 0;
//                                       orderValue = 'rentalPrice';
//                                       // });
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: _selectedValueIndex == 0 ? const Color(0xff626262) : Colors.transparent,
//                                         borderRadius: BorderRadius.circular(11).r,
//                                       ),
//                                       width: 250.w,
//                                       height: 35.h,
//                                       padding: const EdgeInsets.symmetric(horizontal: 10).r,
//                                       margin: const EdgeInsets.symmetric(vertical: 1).r,
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                             'assets/icons/home_list/filter/price_tag.svg',
//                                             height: 30.h,
//                                           ),
//                                           SizedBox(width: 30.w),
//                                           Text(
//                                             'ЦЕНЕ'.toUpperCase(),
//                                             style: GoogleFonts.montserrat(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.white,
//                                               fontSize: AppSizes.productDesc,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       // setState(() {
//                                       _selectedValueIndex = 1;
//                                       orderValue = 'year';
//                                       // });
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: _selectedValueIndex == 1 ? const Color(0xff626262) : Colors.transparent,
//                                         borderRadius: BorderRadius.circular(11).r,
//                                       ),
//                                       width: 250.w,
//                                       height: 35.h,
//                                       padding: const EdgeInsets.symmetric(horizontal: 10).r,
//                                       margin: const EdgeInsets.symmetric(vertical: 1).r,
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                             'assets/icons/home_list/filter/calendar.svg',
//                                             height: 30.h,
//                                           ),
//                                           SizedBox(width: 30.w),
//                                           Text(
//                                             'Году выпуска'.toUpperCase(),
//                                             style: GoogleFonts.montserrat(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.white,
//                                               fontSize: AppSizes.productDesc,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       // setState(() {
//                                       _selectedValueIndex = 2;
//                                       orderValue = 'output';
//                                       // });
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: _selectedValueIndex == 2 ? const Color(0xff626262) : Colors.transparent,
//                                         borderRadius: BorderRadius.circular(11).r,
//                                       ),
//                                       width: 250.w,
//                                       height: 35.h,
//                                       padding: const EdgeInsets.symmetric(horizontal: 10).r,
//                                       margin: const EdgeInsets.symmetric(vertical: 1).r,
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                             'assets/icons/home_list/filter/car_engine.svg',
//                                             height: 30.h,
//                                           ),
//                                           SizedBox(width: 30.w),
//                                           Text(
//                                             'Мощности, л.с.'.toUpperCase(),
//                                             style: GoogleFonts.montserrat(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.white,
//                                               fontSize: AppSizes.productDesc,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       // setState(() {
//                                       _selectedValueIndex = 3;
//                                       orderValue = 'personCount';
//                                       // });
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: _selectedValueIndex == 3 ? const Color(0xff626262) : Colors.transparent,
//                                         borderRadius: BorderRadius.circular(11).r,
//                                       ),
//                                       width: 250.w,
//                                       height: 35.h,
//                                       padding: const EdgeInsets.symmetric(horizontal: 10).r,
//                                       margin: const EdgeInsets.symmetric(vertical: 1).r,
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                             'assets/icons/home_list/filter/people.svg',
//                                             height: 30.h,
//                                           ),
//                                           SizedBox(width: 30.w),
//                                           Text(
//                                             'Кол-ву мест'.toUpperCase(),
//                                             style: GoogleFonts.montserrat(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.white,
//                                               fontSize: AppSizes.productDesc,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       // setState(() {
//                                       _selectedValueIndex = 4;
//                                       orderValue = 'color';
//                                       // });
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: _selectedValueIndex == 4 ? const Color(0xff626262) : Colors.transparent,
//                                         borderRadius: BorderRadius.circular(11).r,
//                                       ),
//                                       width: 250.w,
//                                       height: 35.h,
//                                       padding: const EdgeInsets.symmetric(horizontal: 10).r,
//                                       margin: const EdgeInsets.symmetric(vertical: 1).r,
//                                       child: Row(
//                                         children: [
//                                           SvgPicture.asset(
//                                             'assets/icons/home_list/filter/spray_paint.svg',
//                                             height: 30.r,
//                                           ),
//                                           SizedBox(width: 30.w),
//                                           Text(
//                                             'Цвету авто'.toUpperCase(),
//                                             style: GoogleFonts.montserrat(
//                                               fontWeight: FontWeight.w600,
//                                               color: Colors.white,
//                                               fontSize: AppSizes.productDesc,
//                                             ),
//                                             textAlign: TextAlign.center,
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(height: ScreenUtil().screenHeight < 800 ? 50.h : 35.h),
//                             DecoratedBox(
//                               decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, spreadRadius: 3),
//                                 ],
//                               ),
//                               child: MainButton(
//                                 title: 'Применить',
//                                 borderWidth: 0,
//                                 height: 50,
//                                 width: 200,
//                                 borderColor: Colors.transparent,
//                                 titleColor: Colors.black,
//                                 bgColor: Colors.white,
//                                 fontSize: AppSizes.mainButtonText,
//                                 fontWeight: FontWeight.w600,
//                                 onTap: () {
//                                   final filters = filterState
//                                       .where(
//                                         (element) => element.value,
//                                       )
//                                       .map(
//                                         (e) => e.filterItems.name,
//                                       )
//                                       .toList();
//                                   // context.read<HomeBloc>().add(UpdatedFilterButtonHeight(isExpanded: !state.isExpended));
//                                   // context.read<HomeBloc>().add(FilterAndOrdersChangesEvent(filters, ''));
//                                   setState(() async {
//                                     isExpanded = !isExpanded;
//                                     await _orderValue(orderName);
//                                     await _filterValue(filterName);
//                                     // _isExpanded();
//                                   });
//                                 },
//                                 borderRadius: 8,
//                                 widget: null,
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                           ],
//                         ),
//                         crossFadeState: state.isExpended ? CrossFadeState.showFirst : CrossFadeState.showSecond,
//                         duration: Duration(milliseconds: state.isExpended ? 500 : 2000),
//                         reverseDuration: Duration.zero,
//                         sizeCurve: Curves.fastLinearToSlowEaseIn,
//                       ),
//                     ],
//                   ),
//                 );
//               } else if (state is CarDataError) {
//                 return Center(child: Text(state.error));
//               } else {
//                 return Container();
//               }
//             },
//           );
//         } else if (state is CarDataError) {
//           return Center(child: Text(state.error));
//         } else {
//           return Container();
//         }
//       },
//     );
//   }
// }
// if (filterName == null && orderName == null || filterName!.isEmpty && orderName!.isEmpty) {
//
// }
// if (filterName != null && orderName != null || filterName!.isEmpty && orderName!.isEmpty) {
// carFilterModel = state.carData;
// carsModel = carFilterModel
//     .where(
// (element) => filterName!.contains(
// element.name!.toUpperCase(),
// ),
// )
//     .toList();
// if (orderName == 'rentalPrice') {
// carsModel.sort((a, b) => b.rentalPrice!.compareTo(a.rentalPrice!));
// }
// if (orderName == 'year') {
// carsModel.sort((a, b) => b.year!.compareTo(a.year!));
// }
// if (orderName == 'output') {
// carsModel.sort((a, b) => b.output!.compareTo(a.output!));
// }
// if (orderName == 'personCount') {
// carsModel.sort((a, b) => b.personCount!.compareTo(a.personCount!));
// }
// if (orderName == 'color') {
// carsModel.sort((a, b) => b.color!.compareTo(a.color!));
// }
// }
// if (filterName == null || filterName!.isEmpty) {
// carFilterModel = state.carData;
// carsModel = carFilterModel;
// if (orderName == 'rentalPrice') {
// carsModel.sort((a, b) => b.rentalPrice!.compareTo(a.rentalPrice!));
// }
// if (orderName == 'year') {
// carsModel.sort((a, b) => b.year!.compareTo(a.year!));
// }
// if (orderName == 'output') {
// carsModel.sort((a, b) => b.output!.compareTo(a.output!));
// }
// if (orderName == 'personCount') {
// carsModel.sort((a, b) => b.personCount!.compareTo(a.personCount!));
// }
// if (orderName == 'color') {
// carsModel.sort((a, b) => b.color!.compareTo(a.color!));
// }
// }
// if (kDebugMode) {
// print('home state car data ----> $carsModel');
// }
