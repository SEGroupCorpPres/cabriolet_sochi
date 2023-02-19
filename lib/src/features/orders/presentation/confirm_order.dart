import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/checkout/presentation/successful_checkout.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({super.key});

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  TextEditingController address1TextEditingController = TextEditingController();
  TextEditingController address2TextEditingController = TextEditingController();
  TextEditingController date1TextEditingController = TextEditingController();
  TextEditingController date2TextEditingController = TextEditingController();
  TextEditingController time1TextEditingController = TextEditingController();
  TextEditingController time2TextEditingController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  late List<int> date1 = [];
  late List<int> date2 = [];
  late List<int> time1 = [];
  late List<int> time2 = [];
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _cupertinoDatePicker({required TextEditingController dateTextEditingController}) async {
    Container(
      height: 100.h,
      color: Colors.white,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (date) {
          if (date != _date) {
            _date = date;
            dateTextEditingController.text = _dateFormat.format(date);
          }
          print(_date);
        },
        initialDateTime: DateTime(_date.year),
        minimumYear: DateTime.now().year,
        maximumDate: DateTime(2040),
      ),
    );
    print('cupertino');
  }

  Future<void> _cupertinoTimePicker({required TextEditingController timeTextEditingController}) async {
    Container(
      height: 100.h,
      color: Colors.white,
      child: CupertinoTimerPicker(
        mode: CupertinoTimerPickerMode.hm,
        onTimerDurationChanged: (time) {
          _time = time as TimeOfDay;
          timeTextEditingController.text = time as String;
          print(_date);
        },
      ),
    );
    print('cupertino');
  }

  Future<void> _materialDatePicker({
    required TextEditingController dateTextEditingController,
    required List<int> dateForComparison,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(_date.year,_date.month, _date.day),
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
      helpText: 'ВЫБЕРИТЕ ДАТУ',
      cancelText: 'ОТМЕНА',
      confirmText: 'ВЫБИРАТЬ',
      fieldHintText: 'дд/мм/гггг',
      fieldLabelText: 'Введите дату',
      keyboardType: TextInputType.datetime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // days/years gridview
            textTheme: TextTheme(
              headline5: GoogleFonts.montserrat(),
              // Selected Date landscape
              headline6: GoogleFonts.montserrat(),
              // Selected Date portrait
              overline: GoogleFonts.montserrat(),
              // Title - SELECT DATE
              bodyText1: GoogleFonts.montserrat(),
              // year gridbview picker
              subtitle1: GoogleFonts.montserrat(color: Colors.black),
              // input
              subtitle2: GoogleFonts.montserrat(),
              // month/year picker
              caption: GoogleFonts.montserrat(), // days
            ),
            // Buttons
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: GoogleFonts.montserrat(),
              ),
            ),
            // Input
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: GoogleFonts.montserrat(), // Input label
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != _date) {
      setState(() {
        dateForComparison
          ..add(date!.year)
          ..add(date.month)
          ..add(date.day);
        _date = date;
        dateTextEditingController.text = _dateFormat.format(date);
      });
    }
    print(_date);
  }

  void _dateTimeComparison(List<int>? dateTime1, List<int>? dateTime2) {
    if (dateTime2!.isNotEmpty) {
      if (dateTime2[0] > dateTime1![0]) {
        final yh = dateTime2[0];
        dateTime1[0] = dateTime2[0];
        dateTime2[0] = yh;
      } else if (dateTime2[1] > dateTime1[1]) {
        final mm = dateTime2[1];
        dateTime1[1] = dateTime2[1];
        dateTime2[1] = mm;
      } else if (dateTime2.length == 3 && dateTime1.length == 3) {
        if (dateTime2[3] > dateTime1[3]) {
          final d = dateTime2[3];
          dateTime1[3] = dateTime2[3];
          dateTime2[3] = d;
        }
      }
    }
  }

  Future<void> _materialTimePicker({
    required TextEditingController timeTextEditingController,
    required List<int> timeForComparison,
  }) async {
    final time = await showTimePicker(
      context: context,
      helpText: 'ВЫБЕРИТЕ ДАТУ',
      cancelText: 'ОТМЕНА',
      confirmText: 'ВЫБИРАТЬ',
      initialTime: _time,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() {
        timeForComparison
          ..add(time.hour)
          ..add(time.minute);
        _time = time;
        timeTextEditingController.text = '${time.hour}:${time.minute}';
      });
    }
    print(_date);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    date1TextEditingController.dispose();
    date2TextEditingController.dispose();
    time1TextEditingController.dispose();
    time2TextEditingController.dispose();
    address1TextEditingController.dispose();
    address2TextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AccountButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.adaptive.arrow_back,
        ),
        title: AppBarTitle(
          title: 'Оформление заказа',
          color: AppColors.mainColor,
          fontSize: AppSizes.title,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5).r,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Container(
                  width: 70.r,
                  height: 70.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10).r,
                    color: Colors.black,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/home_list/aston_martin.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  'Mercedes AMG GT S',
                  style: GoogleFonts.montserrat(
                    fontSize: AppSizes.productName,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                subtitle: Text(
                  '557 л.с. 2021г.в. синий',
                  style: GoogleFonts.montserrat(
                    fontSize: AppSizes.productName,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, top: 10, right: 25).r,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20).r,
                        child: Text(
                          'Дата и время начала аренды *',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.fieldText,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: MainTextFormField(
                              textEditingController: date1TextEditingController,
                              horizontalPadding: 10,
                              label: '',
                              labelFontSize: AppSizes.mainButtonText,
                              labelColor: AppColors.textColor,
                              marginContainer: 0,
                              width: 200,
                              height: 35.h,
                              bgColor: Colors.transparent,
                              borderR: 10,
                              keyboardType: TextInputType.text,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              // border: InputBorder.none,
                              onTap: () {
                                Platform.isIOS
                                    ? _cupertinoDatePicker(dateTextEditingController: date1TextEditingController)
                                    : _materialDatePicker(
                                        dateTextEditingController: date1TextEditingController,
                                        dateForComparison: date1,
                                      );
                              },
                              hintText: '23/01/2023',
                              icon: 'assets/icons/pay/calendar.svg',
                              contentPaddingHorizontal: 10,
                              validator: (value) {
                                return value == null || value.isEmpty ? 'Поле не может быть пустым!' : null;
                              },
                              onSaved: (value) {},
                              onChanged: (String? value) {},
                            ),
                          ),
                          Flexible(
                            child: MainTextFormField(
                              textEditingController: time1TextEditingController,
                              horizontalPadding: 10,
                              label: '',
                              labelFontSize: AppSizes.mainButtonText,
                              labelColor: AppColors.textColor,
                              marginContainer: 0,
                              width: 200.w,
                              height: 35.h,
                              bgColor: AppColors.secondColor,
                              borderR: 10,
                              keyboardType: TextInputType.datetime,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                Platform.isIOS
                                    ? _cupertinoTimePicker(timeTextEditingController: time1TextEditingController)
                                    : _materialTimePicker(
                                        timeTextEditingController: time1TextEditingController,
                                        timeForComparison: time1,
                                      );
                              },
                              hintText: '12:00',
                              icon: 'assets/icons/pay/timer.svg',
                              contentPaddingHorizontal: 10,
                              validator: (value) {
                                return value == null || value.isEmpty ? 'Поле не может быть пустым!' : null;
                              },
                              onSaved: (value) {},
                              onChanged: (String? value) {},
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 25).r,
                        child: Text(
                          'Дата и время окончания аренды *',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.fieldText,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: MainTextFormField(
                              textEditingController: date2TextEditingController,
                              horizontalPadding: 10,
                              label: '',
                              labelFontSize: AppSizes.mainButtonText,
                              labelColor: AppColors.textColor,
                              marginContainer: 0,
                              width: 200.w,
                              height: 35.h,
                              bgColor: AppColors.secondColor,
                              borderR: 10,
                              keyboardType: TextInputType.datetime,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                Platform.isIOS
                                    ? _cupertinoDatePicker(dateTextEditingController: date2TextEditingController)
                                    : _materialDatePicker(
                                        dateTextEditingController: date2TextEditingController,
                                        dateForComparison: date2,
                                      );
                              },
                              hintText: '23/01/2023',
                              icon: 'assets/icons/pay/calendar.svg',
                              contentPaddingHorizontal: 10,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Поле не может быть пустым!';
                                } else {
                                  if (date1.isNotEmpty && date2.isNotEmpty) {
                                    if (date1[0] < date2[0]) {
                                      return 'День введен неправильно';
                                    } else if (date1[1] < date2[1]) {
                                      return 'Месяц введен неверно';
                                    } else if (date1[2] < date2[2]) {
                                      return 'Год введен неверно';
                                    }
                                  }
                                  return null;
                                }
                              },
                              onSaved: (value) {},
                              onChanged: (String? value) {},
                            ),
                          ),
                          Flexible(
                            child: MainTextFormField(
                              textEditingController: time2TextEditingController,
                              horizontalPadding: 10,
                              label: '',
                              labelFontSize: AppSizes.mainButtonText,
                              labelColor: AppColors.textColor,
                              marginContainer: 0,
                              width: 200.w,
                              height: 35.h,
                              bgColor: AppColors.secondColor,
                              borderR: 10,
                              keyboardType: TextInputType.datetime,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                Platform.isIOS
                                    ? _cupertinoTimePicker(timeTextEditingController: time2TextEditingController)
                                    : _materialTimePicker(
                                        timeTextEditingController: time2TextEditingController,
                                        timeForComparison: time2,
                                      );
                              },
                              hintText: '12:00',
                              icon: 'assets/icons/pay/timer.svg',
                              contentPaddingHorizontal: 10,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Поле не может быть пустым!';
                                } else {
                                  if (time1.isNotEmpty && time2.isNotEmpty) {
                                    if (time1[0] < time2[0]) {
                                      return 'Часы были введены неправильно';
                                    } else if (time1[1] < time2[1]) {
                                      return 'Неправильно введена минута';
                                    }
                                  }
                                  return null;
                                }
                              },
                              onSaved: (value) {},
                              onChanged: (String? value) {},
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 25).r,
                        child: Text(
                          'Адрес подачи (если требуется)',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.fieldText,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      MainTextFormField(
                        textEditingController: address1TextEditingController,
                        horizontalPadding: 10,
                        label: '',
                        labelFontSize: AppSizes.mainButtonText,
                        labelColor: AppColors.textColor,
                        marginContainer: 0,
                        width: MediaQuery.of(context).size.width,
                        height: 35.h,
                        bgColor: AppColors.secondColor,
                        borderR: 10,
                        keyboardType: TextInputType.streetAddress,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10).r,
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        contentPaddingHorizontal: 10,
                        validator: (value) {
                          return null;

                          // return value == null ?'Поле не может быть пустым!' : null;
                        },
                        onSaved: (value) {},
                        onChanged: (String? value) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 25).r,
                        child: Text(
                          'Адрес возврата',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.fieldText,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      MainTextFormField(
                        textEditingController: address2TextEditingController,
                        horizontalPadding: 10,
                        label: '',
                        labelFontSize: AppSizes.mainButtonText,
                        labelColor: AppColors.textColor,
                        marginContainer: 0,
                        width: MediaQuery.of(context).size.width,
                        height: 35.h,
                        bgColor: AppColors.secondColor,
                        borderR: 10,
                        keyboardType: TextInputType.streetAddress,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10).r,
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        contentPaddingHorizontal: 10,
                        validator: (value) {
                          return  null;
                        },
                        onSaved: (value) {},
                        onChanged: (String? value) {},
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30).r,
                child: MainButton(
                  title: 'Забронировать авто',
                  borderWidth: 0,
                  height: 37.h,
                  width: MediaQuery.of(context).size.width,
                  borderColor: Colors.transparent,
                  titleColor: Colors.white,
                  bgColor: AppColors.mainColor,
                  fontSize: AppSizes.mainButtonText,
                  fontWeight: FontWeight.w400,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(true);
                      Navigator.of(context).push(
                        Platform.isIOS
                            ? CupertinoPageRoute(
                                builder: (_) => const SuccessfulCheckoutScreen(),
                                maintainState: false,
                              )
                            : MaterialPageRoute(
                                builder: (_) => const SuccessfulCheckoutScreen(),
                                maintainState: false,
                              ),
                      );
                    }
                  },
                  borderRadius: 8,
                  widget: null,
                ),
              ),
            ],
          ),
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
