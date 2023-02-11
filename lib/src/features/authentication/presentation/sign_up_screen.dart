import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static Route<void> route() {
    return Platform.isIOS
        ? CupertinoPageRoute<void>(builder: (_) => const SignUpScreen())
        : MaterialPageRoute<void>(
            builder: (_) => const SignUpScreen(),
          );
  }

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _phoneTextEditingController = TextEditingController();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _dateTextEditingController = TextEditingController();
  DateTime _date = DateTime(2020);
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? imageFile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> _getFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    await _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  Future<void> _getFromGallery() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    await _cropImage(pickedFile!.path);
    Navigator.pop(context);
  }

  Future<void> _cropImage(filePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath.toString(),
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  Future<dynamic> _showCupertinoImageDialog() {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            'Пожалуйста, выберите опцию',
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            CupertinoButton(
              onPressed: _getFromCamera,
              child: Row(
                children: [
                  const Icon(CupertinoIcons.camera),
                  Text(
                    'Камера',
                    style: GoogleFonts.montserrat(),
                  )
                ],
              ),
            ),
            CupertinoButton(
              onPressed: _getFromGallery,
              child: Row(
                children: [
                  const Icon(CupertinoIcons.photo_fill_on_rectangle_fill),
                  Text(
                    'Галерея',
                    style: GoogleFonts.montserrat(),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showMaterialImageDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Пожалуйста, выберите опцию',
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            MaterialButton(
              onPressed: _getFromCamera,
              child: Row(
                children: [
                  Icon(Icons.camera),
                  Text(
                    'Камера',
                    style: GoogleFonts.montserrat(),
                  )
                ],
              ),
            ),
            MaterialButton(
              onPressed: _getFromGallery,
              child: Row(
                children: [
                  Icon(Icons.image),
                  Text(
                    'Галерея',
                    style: GoogleFonts.montserrat(),
                  )
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _cupertinoDatePicker() async {
    Container(
      height: 100.h,
      color: Colors.white,
      child: CupertinoDatePicker(
        mode: CupertinoDatePickerMode.date,
        onDateTimeChanged: (date) {
          if (date != _date) {
            _date = date;
            _dateTextEditingController.text = _dateFormat.format(date);
          }
          print(_date);
        },
        initialDateTime: _date,
        minimumYear: 1940,
        maximumDate: DateTime(2020, 12, 31),
      ),
    );
    print('cupertino');
  }

  Future<void> _materialDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1940),
      lastDate: DateTime(2020, 12, 31),
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
        _date = date!;
      });
      _dateTextEditingController.text = _dateFormat.format(date!);
    }
    print('material');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: 'Добро пожаловать в CabrioletSochi !',
          color: Colors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15).r,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Заполните информацию о себе:',
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: AppSizes.mainButtonText,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Center(
                child: Container(
                  width: 100.r,
                  height: 100.r,
                  margin: EdgeInsets.symmetric(vertical: 30.r),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: imageFile == null
                        ? Image.asset('assets/images/splash/auth_profile_pic.png')
                        : Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                            width: 100.r,
                          ),
                  ),
                ),
              ),
              MainButton(
                widget: null,
                title: 'Загрузить фотографию',
                borderWidth: 1.5,
                height: 35,
                width: MediaQuery.of(context).size.width,
                borderColor: AppColors.mainColor,
                titleColor: AppColors.mainColor,
                bgColor: AppColors.secondColor,
                fontSize: AppSizes.mainButtonText,
                fontWeight: FontWeight.w400,
                onTap: () {
                  Platform.isIOS ? _showCupertinoImageDialog() : _showMaterialImageDialog();
                },
                borderRadius: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30).r,
                child: Form(
                  child: Column(
                    children: [
                      MainTextFormField(
                        textEditingController: _nameTextEditingController,
                        horizontalPadding: 0,
                        label: 'Фамилия, Имя',
                        labelFontSize: AppSizes.mainLabel,
                        labelColor: AppColors.labelColor,
                        marginContainer: 10,
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        bgColor: const Color(0xffFFE0E0),
                        borderR: 8,
                        keyboardType: TextInputType.text,
                        border: InputBorder.none,
                        contentPaddingHorizontal: 15,
                        validator: (String? value) {
                          return (value != null) ? 'Не используйте символ.' : null;
                        },
                        onSaved: (String? value) {},
                        onChanged: (String? value) {},
                      ),
                      MainTextFormField(
                        textEditingController: _phoneTextEditingController,
                        horizontalPadding: 0,
                        label: 'Телефон',
                        labelFontSize: AppSizes.mainLabel,
                        labelColor: AppColors.labelColor,
                        marginContainer: 10,
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        bgColor: const Color(0xffFFE0E0),
                        borderR: 8,
                        keyboardType: TextInputType.text,
                        border: InputBorder.none,
                        contentPaddingHorizontal: 15,
                        validator: (String? value) {
                          return (value != null) ? 'Не используйте символ.' : null;
                        },
                        onSaved: (String? value) {},
                        onChanged: (String? value) {},
                      ),
                      MainTextFormField(
                        textEditingController: _dateTextEditingController,
                        horizontalPadding: 0,
                        label: 'Дата рождения',
                        labelFontSize: AppSizes.mainLabel,
                        labelColor: AppColors.labelColor,
                        marginContainer: 10,
                        width: MediaQuery.of(context).size.width,
                        height: 35,
                        bgColor: const Color(0xffFFE0E0),
                        borderR: 8,
                        onTap: Platform.isIOS ? _cupertinoDatePicker : _materialDatePicker,
                        keyboardType: TextInputType.text,
                        border: InputBorder.none,
                        contentPaddingHorizontal: 15,
                        validator: (String? value) {},
                        onSaved: (value) => _date = value! as DateTime,
                        onChanged: (String? value) {},
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Внимание!',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: AppSizes.mainButtonText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Сервис доступен для лиц старше 18 лет.',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: AppSizes.mainButtonText,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50.h),
              MainButton(
                widget: null,
                title: 'Сохранить',
                borderWidth: 0,
                height: 40,
                width: MediaQuery.of(context).size.width,
                borderColor: Colors.transparent,
                titleColor: Colors.white,
                bgColor: AppColors.mainColor,
                fontSize: AppSizes.mainButtonText,
                fontWeight: FontWeight.w400,
                onTap: () => Navigator.of(context).pushReplacement(
                  Platform.isIOS
                      ? CupertinoPageRoute(
                          builder: (_) => const AccountPage(),
                        )
                      : MaterialPageRoute(
                          builder: (_) => const AccountPage(),
                        ),
                ),
                borderRadius: 8,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
