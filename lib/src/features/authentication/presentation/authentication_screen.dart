import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/authentication/bloc/authentication_cubit.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/authentication_confirm.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

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
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(
          title: 'Вход',
          fontWeight: FontWeight.w800,
          color: Colors.black,
          fontSize: AppSizes.cartHistoryProductCost,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Center(
              child: AppBarTitle(
                title: 'Регистрация',
                fontSize: AppSizes.cartHistoryProductCost,
                color: AppColors.mainColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          // TODO: implement listener}
          if (state.status == AuthenticationStatus.authInProgress) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Аутентификация...',
                        style: GoogleFonts.montserrat(),
                      ),
                      const CircularProgressIndicator.adaptive()
                    ],
                  ),
                ),
              );
          }

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

          if (state.status == AuthenticationStatus.otpVerificationSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('OTP успешно подтвержден...'),
                      Icon(Icons.check),
                    ],
                  ),
                ),
              );
            Navigator.of(context).push(
              Platform.isIOS
                  ? CupertinoPageRoute<void>(
                      builder: (_) => const AccountPage(),
                    )
                  : MaterialPageRoute<void>(
                      builder: (_) => const AccountPage(),
                    ),
            );
          }

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
                  ? CupertinoPageRoute(
                      builder: (_) => const AccountPage(),
                    )
                  : MaterialPageRoute(
                      builder: (_) => const AccountPage(),
                    ),
            );
            // Navigator.pushReplacementNamed(context, '/home');
            // context.read<SignInCubit>().sendOtp();
          }

          if (state.status == AuthenticationStatus.exception) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(state.error ?? 'Ошибка аутентификации'),
                      const Icon(Icons.error),
                    ],
                  ),
                ),
              );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 40),
              Form(
                key: formKey,
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
                      keyboardType: TextInputType.number,
                      border: InputBorder.none,
                      contentPaddingHorizontal: 20,
                      textEditingController: phoneTextEditingController,
                      validator: (value) {
                        if (value == null) {
                          return 'Область не может быть пустой';
                        } else if (value.toString().length - 1 < 11) {
                          return 'Номер телефона должен состоять из 11 цифр.';
                        }
                        return null;
                      },
                      onSaved: (value) {},
                      onChanged: (String? value) async {
                        context.read<AuthenticationCubit>().phoneNumberChanged(value!);
                        await SmsAutoFill().getAppSignature;
                      },
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
              Padding(
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
                        await context.read<AuthenticationCubit>().sendOtp();
                      }
                      final preferences = await SharedPreferences.getInstance();
                      await preferences.setString('phone', phoneTextEditingController.text);
                    }
                  },
                  borderRadius: 10,
                ),
              ),
              const SizedBox(height: 50),
            ],
          );
        },
      ),
    );
  }
}
