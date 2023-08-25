import 'dart:io';

import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/car_list/car_list_bloc.dart';
import 'package:cabriolet_sochi/src/features/home/data/models/car_model.dart';
import 'package:cabriolet_sochi/src/features/home/domain/repositories/car_repository.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/widgets/car_list.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/widgets/filter_buton.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static Page<void> page() => Platform.isIOS
      ? const CupertinoPage(
          child: HomePage(),
        )
      : const MaterialPage<void>(
          child: HomePage(),
        );

  static Route<void> route() {
    return Platform.isIOS
        ? CupertinoPageRoute<void>(
            builder: (_) => const HomePage(),
          )
        : MaterialPageRoute<void>(
            builder: (_) => const HomePage(),
          );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<CarModel> carFilterModel = [];
  List<CarModel> carsModel = <CarModel>[];

  late bool isExpanded = true;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final CarRepository carRepository = CarRepository();

  @override
  void initState() {
    // ignore: flutter_style_todos
    // TODO: implement initState
    super.initState();

    BlocProvider.of<CarListBloc>(context).add(GetDataEvent());
    if (kDebugMode) {
      print(ScreenUtil().screenHeight);
    }
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    BlocProvider.of<CarListBloc>(context).add(GetDataEvent());
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
              BlocBuilder<CarListBloc, CarListState>(
                builder: (context, state) {
                  if (state is CarDataLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (state is CarDataLoaded) {
                    carsModel = state.carData;
                    return CarList(carsModel: carsModel);
                  } else if (state is CarDataError) {
                    return Center(child: Text(state.error));
                  } else {
                    if (kDebugMode) {
                      print('Something error');
                    }
                    return Container();
                  }
                },
              ),
              Positioned(
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17).w,
                  child: FilterButton(isExpanded: isExpanded),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isExpanded
          ? AccountPageButton(
              onTap: () => Navigator.of(context).push(
                Platform.isIOS
                    ? CupertinoPageRoute<dynamic>(
                        builder: (_) => const AccountPage(),
                      )
                    : MaterialPageRoute<dynamic>(
                        builder: (_) => const AccountPage(),
                      ),
              ),
            )
          : Container(),
    );
  }
}
