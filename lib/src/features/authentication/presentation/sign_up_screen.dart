import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/authentication/bloc/authentication_cubit.dart';
import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _phoneTextEditingController = TextEditingController();
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _dateTextEditingController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isVisible = true;
  DateTime _date = DateTime.now();
  final DateTime _dateForAge = DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? imageFile;
  String? imageUrl;
  bool _isLoading = false;

  Future<void> _userPhoneNumber() async {
    final preferences = await SharedPreferences.getInstance();
    _phoneTextEditingController.text += preferences.getString('phone') ?? '+';
    // print(object)
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userPhoneNumber();
  }

  Future<void> _saveUserDataToFirebaseFirestore() async {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _formKey.currentState!.save();
      try {
        if (imageFile == null) {
          print('Пожалуйста, выберите изображение');
        } else {
          final ref = FirebaseStorage.instance.ref().child('userimages').child('${_nameTextEditingController.text}.jpg');
          await ref.putFile(imageFile!);
          imageUrl = await ref.getDownloadURL();
          final user = UserModel(
            fullName: _nameTextEditingController.text,
            dateOfBirth: _date,
            email: _emailTextEditingController.text,
            password: _passwordTextEditingController.text,
            imageUrl: imageUrl,
            phoneNumber: _phoneTextEditingController.text,
            id: _firebaseAuth.currentUser!.uid,
          );
          await context.read<AuthenticationCubit>().saveUserProfile(user);
          await Navigator.of(context).pushReplacement(
            AccountPage.route(),
          );
        }
      } catch (error) {
        print('error occurred $error');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void didChangeDependencies() {
    // populateView();
    super.didChangeDependencies();
  }

  void populateView() {
    _nameTextEditingController.text = context.read<AuthenticationCubit>().state.userModel?.fullName ?? '';
    _phoneTextEditingController.text = context.read<AuthenticationCubit>().state.phoneNumber ?? '';
    imageUrl = context.read<AuthenticationCubit>().state.userModel?.imageUrl.toString();
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
    await _cropImage(pickedFile!.path).then((value) => print(imageFile));
    Navigator.pop(context);
  }

  Future<void> _cropImage(String filePath) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: filePath,
      maxHeight: 1080,
      maxWidth: 1080,
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }

  Future<dynamic> _iosBottomSheet() async => showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: _getFromCamera,
                child: const Text('Take Photo'),
              ),
              CupertinoActionSheetAction(
                onPressed: _getFromGallery,
                child: const Text('Choose Photo'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          );
        },
      );

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
                  ),
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
            style: GoogleFonts.montserrat(
              color: AppColors.mainColor,
              fontSize: AppSizes.label,
            ),
          ),
          actions: [
            MaterialButton(
              splashColor: AppColors.mainColor.withOpacity(.1),
              onPressed: _getFromCamera,
              child: Row(
                children: [
                  const Icon(
                    Icons.camera,
                    color: AppColors.mainColor,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Камера',
                    style: GoogleFonts.montserrat(
                      fontSize: AppSizes.label,
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              splashColor: AppColors.mainColor.withOpacity(.1),
              onPressed: _getFromGallery,
              child: Row(
                children: [
                  const Icon(
                    Icons.image,
                    color: AppColors.mainColor,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Галерея',
                    style: GoogleFonts.montserrat(
                      fontSize: AppSizes.label,
                    ),
                  ),
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
        initialDateTime: DateTime(_date.year - 27),
        minimumYear: 1940,
        maximumDate: DateTime(_dateForAge.year - 27, 12, 31),
      ),
    );
    print('cupertino');
  }

  Future<void> _materialDatePicker() async {
    if (_date.year >= _dateForAge.year - 27) {
      _date = DateTime(_dateForAge.year - 27);
    }
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(_date.year),
      firstDate: DateTime(1940),
      lastDate: DateTime(_dateForAge.year - 27, 12, 31),
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
        _dateTextEditingController.text = _dateFormat.format(date);
      });
    }
    print(_date);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _nameTextEditingController.dispose();
    _phoneTextEditingController.dispose();
    _dateTextEditingController.dispose();
    super.dispose();
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
        child: BlocListener<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            // TODO: implement listener}
            if (state.status == AuthenticationStatus.profileUpdateInProgress) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Обновление профиля...'),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
                );
            }
            if (state.status == AuthenticationStatus.profileUpdateComplete) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Профиль успешно обновлен...'),
                        Icon(Icons.check),
                      ],
                    ),
                  ),
                );
              Navigator.of(context).pushReplacement(
                Platform.isIOS
                    ? CupertinoPageRoute<void>(
                        builder: (_) => const AccountPage(),
                      )
                    : MaterialPageRoute<void>(
                        builder: (_) => const AccountPage(),
                      ),
              );
            }
            if (state.status == AuthenticationStatus.exception) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Ошибка аутентификации'),
                        Icon(Icons.error),
                      ],
                    ),
                  ),
                );
            }
          },
          child: Padding(
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
                    height: 35.h,
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
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        children: [
                          MainTextFormField(
                            textEditingController: _emailTextEditingController,
                            horizontalPadding: 0,
                            label: 'Электронная почта',
                            labelFontSize: AppSizes.mainLabel,
                            labelColor: AppColors.labelColor,
                            marginContainer: 10,
                            width: MediaQuery.of(context).size.width,
                            height: 35.h,
                            bgColor: const Color(0xffFFE0E0),
                            borderR: 8,
                            keyboardType: TextInputType.emailAddress,
                            border: InputBorder.none,
                            errorText: _emailTextEditingController.text.isEmpty ? 'Электронная почта не должны быть пустыми' : null,
                            contentPaddingHorizontal: 15,
                            onChanged: (String? value) {},
                            obscureText: false,
                          ),
                          MainTextFormField(
                            textEditingController: _passwordTextEditingController,
                            horizontalPadding: 0,
                            label: 'Пароль от электронной почты',
                            labelFontSize: AppSizes.mainLabel,
                            labelColor: AppColors.labelColor,
                            marginContainer: 10,
                            width: MediaQuery.of(context).size.width,
                            obscureText: isVisible,
                            height: 35.h,
                            bgColor: const Color(0xffFFE0E0),
                            borderR: 8,
                            keyboardType: TextInputType.text,
                            border: InputBorder.none,
                            errorText: _passwordTextEditingController.text.isEmpty ? 'Область не может быть пустой' : null,
                            contentPaddingHorizontal: 15,
                            icon: isVisible ? 'assets/icons/profile/eye_off.svg' : 'assets/icons/profile/eye.svg',
                            size: 20,
                            onChanged: (String? value) {},
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            isPassword: true,
                          ),
                          MainTextFormField(
                            textEditingController: _nameTextEditingController,
                            horizontalPadding: 0,
                            label: 'Фамилия, Имя',
                            labelFontSize: AppSizes.mainLabel,
                            labelColor: AppColors.labelColor,
                            marginContainer: 10,
                            width: MediaQuery.of(context).size.width,
                            height: 35.h,
                            bgColor: const Color(0xffFFE0E0),
                            borderR: 8,
                            keyboardType: TextInputType.text,
                            border: InputBorder.none,
                            errorText: _nameTextEditingController.text.isEmpty ? 'Фамилия и Имя не должны быть пустыми' : null,
                            contentPaddingHorizontal: 15,
                            onChanged: (String? value) {},
                            obscureText: false,
                          ),
                          MainTextFormField(
                            obscureText: false,
                            textEditingController: _phoneTextEditingController,
                            horizontalPadding: 0,
                            label: 'Телефон',
                            labelFontSize: AppSizes.mainLabel,
                            labelColor: AppColors.labelColor,
                            marginContainer: 10,
                            width: MediaQuery.of(context).size.width,
                            height: 35.h,
                            bgColor: const Color(0xffFFE0E0),
                            borderR: 8,
                            keyboardType: TextInputType.phone,
                            border: InputBorder.none,
                            contentPaddingHorizontal: 15,
                            errorText: _phoneTextEditingController.text.isEmpty
                                ? 'Область не может быть пустой'
                                : _phoneTextEditingController.text.length - 1 < 7
                                    ? 'Номер телефона должен состоять из 7 цифр.'
                                    : null,
                            onChanged: (String? value) {},
                          ),
                          MainTextFormField(
                            obscureText: false,
                            textEditingController: _dateTextEditingController,
                            horizontalPadding: 0,
                            label: 'Дата рождения',
                            labelFontSize: AppSizes.mainLabel,
                            labelColor: AppColors.labelColor,
                            marginContainer: 10,
                            width: MediaQuery.of(context).size.width,
                            height: 35.h,
                            bgColor: const Color(0xffFFE0E0),
                            borderR: 8,
                            onTap: Platform.isIOS ? _cupertinoDatePicker : _materialDatePicker,
                            keyboardType: TextInputType.text,
                            border: InputBorder.none,
                            contentPaddingHorizontal: 15,
                            errorText: _dateTextEditingController.text.isEmpty ? 'Дата рождения не может быть пустой' : null,
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
                    height: 40.h,
                    width: MediaQuery.of(context).size.width,
                    borderColor: Colors.transparent,
                    titleColor: Colors.white,
                    bgColor: AppColors.mainColor,
                    fontSize: AppSizes.mainButtonText,
                    fontWeight: FontWeight.w400,
                    onTap: _saveUserDataToFirebaseFirestore,
                    borderRadius: 8,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
