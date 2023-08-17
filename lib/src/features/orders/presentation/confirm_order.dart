import 'dart:io';
import 'dart:math';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/bloc/account_bloc.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/checkout/presentation/successful_checkout.dart';
import 'package:cabriolet_sochi/src/features/home/bloc/home_bloc.dart';
import 'package:cabriolet_sochi/src/features/orders/cubit/orders_cubit.dart';
import 'package:cabriolet_sochi/src/features/orders/data/models/order_model.dart';
import 'package:cabriolet_sochi/src/utils/services/order_notification.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

/// ConfirmOrderScreen
class ConfirmOrderPage extends StatefulWidget {
  /// constructor for Confirm Order Screen
  const ConfirmOrderPage({
    super.key,
    required this.carId,
  });

  /// Selected car id;
  final int? carId;

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  int? carId;
  int rentalPrice = 0;
  String? carName;
  String carImgUrl = '';
  TextEditingController address1TextEditingController = TextEditingController();
  TextEditingController address2TextEditingController = TextEditingController();
  TextEditingController date1TextEditingController = TextEditingController();
  TextEditingController date2TextEditingController = TextEditingController();
  TextEditingController time1TextEditingController = TextEditingController();
  TextEditingController time2TextEditingController = TextEditingController();
  bool useTempDirectory = true;
  List<String> attachment = <String>[];
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Map<String, dynamic>? userModel = {};
  int orderId = 0;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  DateTime _timeCupertino = DateTime.now();
  DateTime? dateFrom;
  DateTime? dateTo;
  late List<int> date1 = [];
  late List<int> date2 = [];
  late List<int> time1 = [];
  late List<int> time2 = [];
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // ignore: flutter_style_todos
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AccountBloc>(context).add(GetData());
    carId = widget.carId;
  }

  void generateOrderId() {
    orderId = Random().nextInt(10000000) + 3000;
  }

  int daysBetween(List<int> from, List<int> to) {
    dateFrom = DateTime(from[0], from[1], from[2]);
    dateTo = DateTime(to[0], to[1], to[2]);
    return (dateTo!.difference(dateFrom!).inHours / 24).round();
  }

  int price(int rentalPrice) {
    return rentalPrice * daysBetween(date1, date2);
  }

  Future<void> _saveUserDataToFirebaseFirestore(
    int price,
    String carName,
    Map<String, dynamic>? userModel,
  ) async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {});
      _formKey.currentState!.save();
      try {
        final orderModel = OrderModel(
          id: orderId,
          carId: carId,
          userId: _firebaseAuth.currentUser!.uid ?? '',
          carName: carName,
          rentalPrice: price,
          fillingAddress: address1TextEditingController.text,
          returnAddress: address2TextEditingController.text,
          rentalStartDateTime: DateTime(
            date1[0],
            date1[1],
            date1[2],
            time1[0],
            time1[1],
          ),
          rentalEndDateTime: DateTime(
            date2[0],
            date2[1],
            date2[2],
            time2[0],
            time2[1],
          ),
        );

        await context.read<OrdersCubit>().saveOrderData(orderModel, orderId.toString());
      } catch (error) {
        if (kDebugMode) {
          print('error occurred $error');
        }
      } finally {
        setState(() {});
      }
    }
  }

  Future<void> _createOrderExcel({
    required String? uid,
    required String? userImg,
    required String? fullName,
    required String? phoneNumber,
    required String? dateOfBirth,
    required double orderId,
    required double carId,
    required String carName,
    required double rentalPrice,
    required String rentalStartDate,
    required String rentalEndDate,
    required String orderCreatedTime,
    required String fillingAddress,
    required String returnAddress,
  }) async {
    final workbook = xlsio.Workbook();
    final workSheet = workbook.worksheets[0];
    workSheet.getRangeByName('B3').setText('Key');
    workSheet.getRangeByName('B4').setText('uid');
    workSheet.getRangeByName('B5').setText('user_img');
    workSheet.getRangeByName('B6').setText('full_name');
    workSheet.getRangeByName('B7').setText('phone_number');
    workSheet.getRangeByName('B8').setText('date_of_birth');
    workSheet.getRangeByName('B9').setText('order_id');
    workSheet.getRangeByName('B10').setText('car_id');
    workSheet.getRangeByName('B11').setText('car_name');
    workSheet.getRangeByName('B12').setText('rental_price');
    workSheet.getRangeByName('B13').setText('rental_start_date');
    workSheet.getRangeByName('B14').setText('rental_end_date');
    workSheet.getRangeByName('B15').setText('filling_address');
    workSheet.getRangeByName('B16').setText('return_address');
    workSheet.getRangeByName('B17').setText('order_created_date');
    workSheet.getRangeByName('C3').setText('Value');
    workSheet.getRangeByName('C4').setText(uid ?? '');
    workSheet.getRangeByName('C5').setText(userImg ?? '');
    workSheet.getRangeByName('C6').setText(fullName ?? '');
    workSheet.getRangeByName('C7').setText(phoneNumber ?? '');
    workSheet.getRangeByName('C8').setText(dateOfBirth ?? '');
    workSheet.getRangeByName('C9').setNumber(orderId);
    workSheet.getRangeByName('C10').setNumber(carId);
    workSheet.getRangeByName('C11').setText(carName);
    workSheet.getRangeByName('C12').setNumber(rentalPrice);
    workSheet.getRangeByName('C13').setText(rentalStartDate);
    workSheet.getRangeByName('C14').setText(rentalStartDate);
    workSheet.getRangeByName('C15').setText(fillingAddress);
    workSheet.getRangeByName('C16').setText(returnAddress);
    workSheet.getRangeByName('C17').setText(orderCreatedTime);

    final bytes = workbook.saveAsStream();
    workbook.dispose();
    final path = (await getApplicationSupportDirectory()).path;
    final fileName = '$path/UserOrders.xlsx';
    final file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
  }

  Future<void> _sendWithEmail(
    String carName,
  ) async {
    final path = (await getApplicationSupportDirectory()).path;
    final fileName = '$path/UserOrders.xlsx';
    // Platform messages may fail, so we use a try/catch PlatformException.
    String? platformResponse = '';
    try {
      final email = Email(
        body: 'Информация, предоставленная пользователем fullName для аренды и возврата автомобиля $carName',
        subject: 'Договор аренды кабриолета',
        // recipients: <String>['cabrioletsochi2012@yandex.ru'],
        // recipients: <String> ['vladislav.vulf@gmail.com'],
        recipients: <String>['artessdu@gmail.com'],
        attachmentPaths: [fileName],
      );

      await FlutterEmailSender.send(email);
    } on PlatformException catch (error) {
      platformResponse = error.toString();
      print(error);
      if (!mounted) {
        return;
      }
    } catch (error) {
      platformResponse = error.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }
  }

  Future<dynamic> showCupertinoSheet(
    BuildContext context, {
    required Widget child,
    required VoidCallback onClicked,
    required String text,
  }) =>
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            child,
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: onClicked,
            child: Text(
              text,
              style: GoogleFonts.montserrat(),
            ),
          ),
        ),
      );

  Widget cupertinoDatePicker(double bR, TextEditingController textEditingController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(bR),
        color: Colors.white,
      ),
      height: 100.h,
      child: CupertinoDatePicker(
        dateOrder: DatePickerDateOrder.dmy,
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (date) {
          if (date != _date) {
            _date = date;
            textEditingController.text = _dateFormat.format(date);
          }
          print(_date);
        },
        initialDateTime: DateTime.now(),
        minimumYear: DateTime.now().year,
        maximumDate: DateTime(2100),
      ),
    );
  }

  Widget cupertinoTimePicker(double bR, TextEditingController textEditingController) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(bR),
        color: Colors.white,
      ),
      height: 100.h,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.time,
        initialDateTime: DateTime.now(),
        use24hFormat: true,
        onDateTimeChanged: (time) {
          _timeCupertino = time;
          textEditingController.text = time.hour < 10 && time.minute < 10
              ? '0${time.hour}:0${time.minute}'
              : time.minute < 10
                  ? '${time.hour}:0${time.minute}'
                  : time.hour < 10
                      ? '0${time.hour}:${time.minute}'
                      : '${time.hour}:${time.minute}';
          if (kDebugMode) {
            print(_timeCupertino);
          }
        },
      ),
    );
  }

  Future<void> _buildCupertinoDatePicker(TextEditingController textEditingController) async {
    await showCupertinoSheet(
      context,
      text: 'Сохранить',
      child: cupertinoDatePicker(8, textEditingController),
      onClicked: () => Navigator.pop(context),
    );
  }

  Future<void> _buildCupertinoTimePicker(TextEditingController textEditingController) async {
    await showCupertinoSheet(
      context,
      text: 'Сохранить',
      child: cupertinoTimePicker(8, textEditingController),
      onClicked: () => Navigator.pop(context),
    );
  }

  Future<void> _materialDatePicker({
    required TextEditingController dateTextEditingController,
    required List<int> dateForComparison,
  }) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(_date.year, _date.month, _date.day),
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
    if (kDebugMode) {
      print(_date);
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
    if (kDebugMode) {
      print(_date);
    }
  }

  @override
  void dispose() {
    // ignore: flutter_style_todos
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5).r,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is CarDataLoading) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator.adaptive()),
                    );
                  } else if (state is CarDataLoaded) {
                    final carModel = state.carData;
                    rentalPrice = carModel[carId!].rentalPrice!;
                    carName = '${carModel[carId!].name} ${carModel[carId!].model} ${carModel[carId!].year}';
                    carImgUrl = carModel[0].images![0]!;
                    return ListTile(
                      leading: Container(
                        width: 70.r,
                        height: 70.r,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10).r,
                          color: Colors.black,
                          image: DecorationImage(
                            image: NetworkImage(
                              carModel[carId!].images![0].toString(),
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        '${carModel[carId!].name} ${carModel[carId!].model}',
                        style: GoogleFonts.montserrat(
                          fontSize: AppSizes.productName,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textColor,
                        ),
                      ),
                      subtitle: Text(
                        carModel[carId!].description!,
                        style: GoogleFonts.montserrat(
                          fontSize: AppSizes.productName,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 5,
                  left: 5,
                  top: 10,
                  right: 5,
                ).r,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.disabled,
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
                            child: SizedBox(
                              height: 65.h,
                              child: MainTextFormField(
                                textEditingController: date1TextEditingController,
                                horizontalPadding: 10,
                                label: '',
                                labelFontSize: AppSizes.mainButtonText,
                                labelColor: AppColors.textColor,
                                marginContainer: 0,
                                width: 200,
                                height: 35,
                                bgColor: Colors.transparent,
                                borderR: 10,
                                size: 20,
                                focusedBorderColor: AppColors.mainColor,
                                enableBorderColor: AppColors.mainColor,
                                errorBorderColor: Colors.red,
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10).r,
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                onTap: () {
                                  Platform.isIOS
                                      ? _buildCupertinoDatePicker(
                                          date1TextEditingController,
                                        )
                                      : _materialDatePicker(
                                          dateTextEditingController: date1TextEditingController,
                                          dateForComparison: date1,
                                        );
                                },
                                hintText: '23/01/2023',
                                icon: 'assets/icons/pay/calendar.svg',
                                contentPaddingHorizontal: 10,
                                errorText: date1TextEditingController.text.isEmpty ? 'Поле не может быть пустым!' : null,
                                onChanged: (String? value) {},
                                visible: date1TextEditingController.value.text.length < 2,
                              ),
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
                              height: 65.h,
                              child: MainTextFormField(
                                obscureText: false,
                                textEditingController: time1TextEditingController,
                                horizontalPadding: 10,
                                label: '',
                                labelFontSize: AppSizes.mainButtonText,
                                labelColor: AppColors.textColor,
                                marginContainer: 0,
                                width: 200,
                                height: 35,
                                size: 20,
                                focusedBorderColor: AppColors.mainColor,
                                enableBorderColor: AppColors.mainColor,
                                errorBorderColor: Colors.red,
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
                                      ? _buildCupertinoTimePicker(time1TextEditingController)
                                      : _materialTimePicker(
                                          timeTextEditingController: time1TextEditingController,
                                          timeForComparison: time1,
                                        );
                                },
                                hintText: '12:00',
                                icon: 'assets/icons/pay/timer.svg',
                                contentPaddingHorizontal: 10,
                                errorText: time1TextEditingController.text.isEmpty ? 'Поле не может быть пустым!' : null,
                                onChanged: (String? value) {},
                                visible: date1TextEditingController.value.text.length < 2,

                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 25).r,
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
                            child: SizedBox(
                              height: 65.h,
                              child: MainTextFormField(
                                obscureText: false,
                                textEditingController: date2TextEditingController,
                                horizontalPadding: 10,
                                label: '',
                                labelFontSize: AppSizes.mainButtonText,
                                labelColor: AppColors.textColor,
                                marginContainer: 0,
                                width: 200,
                                height: 35,
                                bgColor: AppColors.secondColor,
                                borderR: 10,
                                size: 20,
                                focusedBorderColor: AppColors.mainColor,
                                enableBorderColor: AppColors.mainColor,
                                errorBorderColor: Colors.red,
                                keyboardType: TextInputType.datetime,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10).r,
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                onTap: () {
                                  Platform.isIOS
                                      ? _buildCupertinoDatePicker(date2TextEditingController)
                                      : _materialDatePicker(
                                          dateTextEditingController: date2TextEditingController,
                                          dateForComparison: date2,
                                        );
                                },
                                hintText: '23/01/2023',
                                icon: 'assets/icons/pay/calendar.svg',
                                contentPaddingHorizontal: 10,
                                errorText: date2TextEditingController.text.isEmpty ? 'Поле не может быть пустым!' : null,
                                onChanged: (String? value) {},
                                visible: date1TextEditingController.value.text.length < 2,

                              ),
                            ),
                          ),
                          Flexible(
                            child: SizedBox(
                              height: 65.h,
                              child: MainTextFormField(
                                obscureText: false,
                                textEditingController: time2TextEditingController,
                                horizontalPadding: 10,
                                label: '',
                                labelFontSize: AppSizes.mainButtonText,
                                labelColor: AppColors.textColor,
                                marginContainer: 0,
                                width: 200,
                                height: 35,
                                bgColor: AppColors.secondColor,
                                borderR: 10,
                                size: 20,
                                focusedBorderColor: AppColors.mainColor,
                                enableBorderColor: AppColors.mainColor,
                                errorBorderColor: Colors.red,
                                keyboardType: TextInputType.datetime,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10).r,
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                onTap: () {
                                  Platform.isIOS
                                      ? _buildCupertinoTimePicker(time2TextEditingController)
                                      : _materialTimePicker(
                                          timeTextEditingController: time2TextEditingController,
                                          timeForComparison: time2,
                                        );
                                },
                                hintText: '12:00',
                                icon: 'assets/icons/pay/timer.svg',
                                contentPaddingHorizontal: 10,
                                errorText: time2TextEditingController.text.isEmpty ? 'Поле не может быть пустым!' : null,
                                onChanged: (String? value) {},
                                visible: date1TextEditingController.value.text.length < 2,

                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 25).r,
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
                        obscureText: false,
                        textEditingController: address1TextEditingController,
                        horizontalPadding: 10,
                        label: '',
                        labelFontSize: AppSizes.mainButtonText,
                        labelColor: AppColors.textColor,
                        marginContainer: 0,
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        bgColor: AppColors.secondColor,
                        borderR: 10,
                        keyboardType: TextInputType.streetAddress,
                        focusedBorderColor: AppColors.mainColor,
                        enableBorderColor: AppColors.mainColor,
                        errorBorderColor: Colors.red,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10).r,
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        contentPaddingHorizontal: 10,
                        onChanged: (String? value) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 25).r,
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
                        obscureText: false,
                        label: '',
                        labelFontSize: AppSizes.mainButtonText,
                        labelColor: AppColors.textColor,
                        marginContainer: 0,
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        bgColor: AppColors.secondColor,
                        borderR: 10,
                        focusedBorderColor: AppColors.mainColor,
                        enableBorderColor: AppColors.mainColor,
                        errorBorderColor: Colors.red,
                        keyboardType: TextInputType.streetAddress,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10).r,
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        contentPaddingHorizontal: 10,
                        onChanged: (String? value) {},
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30).r,
                child: BlocBuilder<AccountBloc, AccountState>(
                  builder: (context, state) {
                    if (state is UserDataLoaded) {
                      userModel = {
                        'id': state.userData['id'],
                        'fullName': state.userData['fullName'],
                        'imageUrl': state.userData['imageUrl'],
                        'phoneNumber': state.userData['phoneNumber'],
                        'email': state.userData['email'],
                        'password': state.userData['password'],
                        'dateOfBirth': state.userData['dateOfBirth']
                      };
                      print(userModel);
                      return MainButton(
                        title: 'Забронировать авто',
                        borderWidth: 0,
                        height: 37,
                        width: MediaQuery.of(context).size.width,
                        borderColor: Colors.transparent,
                        titleColor: Colors.white,
                        bgColor: AppColors.mainColor,
                        fontSize: AppSizes.mainButtonText,
                        fontWeight: FontWeight.w400,
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            rentalPrice = price(rentalPrice);
                            generateOrderId();
                            await _saveUserDataToFirebaseFirestore(
                              rentalPrice,
                              carName!,
                              userModel,
                            ).then(
                              (value) async => _createOrderExcel(
                                uid: _firebaseAuth.currentUser?.uid ?? '',
                                userImg: userModel?['imageUrl'].toString() ?? '',
                                fullName: userModel?['fullName'].toString() ?? '',
                                phoneNumber: userModel?['phoneNumber'].toString() ?? '',
                                dateOfBirth: userModel?['dateOfBirth'].toString() ?? '',
                                orderId: orderId.toDouble(),
                                carId: carId!.toDouble(),
                                carName: carName!,
                                rentalPrice: rentalPrice.toDouble(),
                                rentalStartDate: DateTime(
                                  date1[0],
                                  date1[1],
                                  date1[2],
                                  time1[0],
                                  time1[1],
                                ).toString(),
                                rentalEndDate: DateTime(
                                  date2[0],
                                  date2[1],
                                  date2[2],
                                  time2[0],
                                  time2[1],
                                ).toString(),
                                orderCreatedTime: DateTime.now().toString(),
                                fillingAddress: address1TextEditingController.text,
                                returnAddress: address2TextEditingController.text,
                              )
                                  .then(
                                    (value) async => _sendWithEmail(
                                      carName!,
                                    ),
                                  )
                                  .then(
                                    (value) => Navigator.of(context).pushAndRemoveUntil(
                                      Platform.isIOS
                                          ? CupertinoPageRoute<void>(
                                              builder: (_) => SuccessfulCheckoutScreen(
                                                orderId: orderId,
                                                index: carId,
                                              ),
                                              maintainState: false,
                                            )
                                          : MaterialPageRoute<void>(
                                              builder: (_) => SuccessfulCheckoutScreen(
                                                orderId: orderId,
                                                index: carId,
                                              ),
                                              maintainState: false,
                                            ),
                                      (route) => true,
                                    ),
                                  )
                                  .then((value) async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setInt('orderId', orderId);
                                await prefs.setString('carName', carName!);
                                await prefs.setStringList(
                                  'date2',
                                  <String>[date2[0].toString(), date2[1].toString(), date2[2].toString(), time2[0].toString(), time2[1].toString()],
                                );
                                await prefs.setString(
                                  'userImgUrl',
                                  userModel!['imageUrl']!.toString(),
                                );
                                await prefs.setString('carImgUrl', carImgUrl);
                                final isNotify = prefs.getBool('isNotify');
                                if (isNotify!) {
                                  print(isNotify);
                                  return await OrderNotificationService().showNotification(
                                    title: 'Поздравляем!',
                                    body: 'Вы забронировали автомобиль $carName до $date2 $time2',
                                    userImgUrl: userModel!['imageUrl']!.toString(),
                                    carImgUrl: carImgUrl,
                                  );
                                }
                              }),
                            );
                            if (kDebugMode) {
                              print(true);
                            }
                          }
                        },
                        borderRadius: 8,
                        widget: null,
                      );
                    } else if (state is UserDataLoading) {
                      return const Center(child: CircularProgressIndicator.adaptive());
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AccountPageButton(
        onTap: () => Navigator.of(context).push(
          Platform.isIOS
              ? CupertinoPageRoute<void>(
                  builder: (_) => const AccountPage(),
                )
              : MaterialPageRoute<void>(
                  builder: (_) => const AccountPage(),
                ),
        ),
      ),
    );
  }
}
