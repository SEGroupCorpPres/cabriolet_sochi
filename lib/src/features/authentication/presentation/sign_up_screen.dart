import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late TextEditingController phoneTextEditingController;
  late TextEditingController nameTextEditingController;
  late TextEditingController dateTextEditingController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        padding: const EdgeInsets.symmetric(horizontal: 15.0).r,
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
                  margin: const EdgeInsets.symmetric(vertical: 30).h,
                  width: 100.r,
                  height: 100.r,
                  child: Image.asset(
                    'assets/images/splash/auth_profile_pic.png',
                    fit: BoxFit.cover,
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
                onTap: () {},
                borderRadius: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30).r,
                child: Form(
                  child: Column(
                    children: [
                      MainTextFormField(
                        textEditingController: nameTextEditingController,
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
                        validator: (String? value){return (value != null) ? 'Do not use the @ char.' : null;},
                        onSaved: (String? value){},
                        onChanged: (String? value){},
                      ),
                      MainTextFormField(
                        textEditingController: phoneTextEditingController,
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
                        validator: (String? value){return (value != null) ? 'Do not use the @ char.' : null;},
                        onSaved: (String? value){},
                        onChanged: (String? value){},
                      ),
                      MainTextFormField(
                        textEditingController: dateTextEditingController,
                        horizontalPadding: 0,
                        label: 'Дата рождения',
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
                        validator: (String? value){return (value != null) ? 'Do not use the @ char.' : null;},
                        onSaved: (String? value){},
                        onChanged: (String? value){},
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
                  MaterialPageRoute(
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
