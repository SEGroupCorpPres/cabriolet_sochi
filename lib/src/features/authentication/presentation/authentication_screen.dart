import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/authentication/bloc/authentication_cubit.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/authentication_confirm.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  static Route<void> route() {
    return Platform.isIOS
        ? CupertinoPageRoute<void>(builder: (_) => const AuthenticationScreen())
        : MaterialPageRoute<void>(
            builder: (_) => const AuthenticationScreen(),
          );
  }

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  late TextEditingController phoneTextEditingController;
  TextEditingController phoneText = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool isChecked = false;
  final _navigatorKey = GlobalKey<NavigatorState>();
  late bool isPhoneNumberSent = false;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    // TODO: implement initState
    phoneTextEditingController = TextEditingController();
    phoneTextEditingController.text += '+';
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    phoneTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: 'Вход/Регистрация',
          fontWeight: FontWeight.w800,
          color: Colors.black,
          fontSize: AppSizes.cartHistoryProductCost,
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
        child: BlocConsumer<AuthenticationCubit, AuthenticationState>(
          listener: (context, state) {
            if (state.status == AuthenticationStatus.otpSent) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('OTP отправлен...'),
                        Icon(Icons.check),
                      ],
                    ),
                  ),
                );
              Navigator.of(context).push(
                Platform.isIOS
                    ? CupertinoPageRoute<void>(
                        builder: (_) => AuthenticationConfirm(
                          phoneNumber: phoneTextEditingController.text,
                        ),
                      )
                    : MaterialPageRoute<void>(
                        builder: (_) => AuthenticationConfirm(
                          phoneNumber: phoneTextEditingController.text,
                        ),
                      ),
              );
            }
          },
          builder: (context, state) {
            // ignore: flutter_style_todos
            // TODO: implement listener

            if (state.status == AuthenticationStatus.isWaitingOtp) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else {
              return Column(
                children: [
                  const SizedBox(height: 40),
                  Form(
                    key: formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        MainTextFormField(
                          horizontalPadding: 20,
                          label: 'Номер телефона',
                          labelFontSize: AppSizes.mainLabel,
                          labelColor: AppColors.labelColor,
                          marginContainer: 10,
                          width: MediaQuery.of(context).size.width,
                          bgColor: const Color(0xffEBF7EE),
                          borderR: 8,
                          height: 32.h,
                          obscureText: false,
                          keyboardType: TextInputType.phone,
                          border: InputBorder.none,
                          contentPaddingHorizontal: 20,
                          inputFormatters: [
                            TextInputMask(
                              mask: r'\+ 999 (99) 999 99 99',
                              placeholder: '_ ',
                              maxPlaceHolders: 13,
                            ),
                          ],
                          textEditingController: phoneTextEditingController,
                          errorText: phoneTextEditingController.text == null
                              ? 'Область не может быть пустой'
                              : phoneTextEditingController.text.length - 1 < 7
                                  ? 'Номер телефона должен состоять из 7 цифр.'
                                  : null,
                          onChanged: (String? value) async {},
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: Row(
                      children: [
                        Checkbox(
                          checkColor: AppColors.secondColor,
                          activeColor: AppColors.mainColor,
                          focusColor: AppColors.secondColor.withOpacity(0.4),
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value!;
                            });
                          },
                          splashRadius: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.5),
                            side: const BorderSide(),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Column(
                            children: [
                              Text.rich(
                                textAlign: TextAlign.start,
                                softWrap: true,
                                TextSpan(
                                  text: 'Я согласен с ',
                                  style: GoogleFonts.montserrat(),
                                  children: [
                                    TextSpan(
                                      text: 'правилами обработки персональных данных',
                                      style: GoogleFonts.montserrat(color: AppColors.mainColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isChecked,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: MainButton(
                        widget: null,
                        title: 'Далее',
                        borderWidth: 0,
                        height: 40.h,
                        width: MediaQuery.of(context).size.width,
                        borderColor: Colors.transparent,
                        titleColor: Colors.white,
                        bgColor: AppColors.mainColor,
                        fontSize: AppSizes.mainButtonText,
                        fontWeight: FontWeight.w400,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (isChecked) {
                              context.read<AuthenticationCubit>().phoneNumberChanged(phoneTextEditingController.text);
                              await context.read<AuthenticationCubit>().sendOtp();
                              Future.delayed(Duration.zero, () {
                                isPhoneNumberSent = true;
                              });
                            }
                            final preferences = await SharedPreferences.getInstance();
                            await preferences.setString('phone', phoneTextEditingController.text);
                          }
                        },
                        borderRadius: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
