import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/authentication/bloc/authentication_cubit.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/authentication_confirm.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Authentication Screen
class AuthenticationScreen extends StatefulWidget {
  /// Constructor for the Authentication Screen
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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late bool isChecked = false;
  final _navigatorKey = GlobalKey<NavigatorState>();
  late bool isPhoneNumberSent = false;
  String _text = '';
  String initialCountry = 'RU';
  PhoneNumber number = PhoneNumber(isoCode: 'RU');

  NavigatorState get _navigator => _navigatorKey.currentState!;
  FocusNode focusNode = FocusNode();

  String? get _errorText {
    // at any time, we can get the text from _controller.value.text
    final text = phoneTextEditingController.value.text;
    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.length == 4) {
      return 'Область не может быть пустой';
    }
    if (text.length < 7) {
      return 'Номер телефона должен состоять из 7 цифр.';
    }
    // return null if the text is valid
    return null;
  }

  Future<void> getPhoneNumber(String phoneNumber) async {
    final number = await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'RU');

    setState(() {
      this.number = number;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    phoneTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    phoneTextEditingController.dispose();
    super.dispose();
  }
  void _unfocusTextFormField() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                  ValueListenableBuilder(
                    // Note: pass _controller to the animation argumen
                    valueListenable: phoneTextEditingController,
                    builder: (context, TextEditingValue value, __) {
                      // this entire widget tree will rebuild every time
                      // the controller value changes
                      return Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.disabled,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Номер телефона',
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.montserrat(
                                      fontSize: AppSizes.label,
                                      color: AppColors.labelColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Color(0xFFEBF7EE),
                                ),
                                child: InternationalPhoneNumberInput(
                                  focusNode: focusNode,
                                  onInputValidated: (bool value) {
                                  },
                                  locale: 'ru',
                                  hintText: 'Номер телефона',
                                  onInputChanged: (PhoneNumber text) {
                                    setState(() {
                                      _text = text.phoneNumber!;
                                    });
                                    print(_text);
                                  },
                                  spaceBetweenSelectorAndTextField: 0,
                                  selectorConfig: SelectorConfig(
                                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                                    setSelectorButtonAsPrefixIcon: true,
                                    trailingSpace: false,
                                    leadingPadding: 20.r,
                                  ),
                                  errorMessage: _errorText,
                                  textStyle: TextStyle(color: Colors.black, fontSize: 20.sp,),
                                  selectorTextStyle: TextStyle(color: Colors.black, fontSize: 20.sp),
                                  initialValue: number,
                                  textFieldController: phoneTextEditingController,
                                  inputBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
                            _unfocusTextFormField();
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
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20).r,
                      child: MainButton(
                        widget: null,
                        title: 'Далее',
                        borderWidth: 0,
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        borderColor: Colors.transparent,
                        titleColor: Colors.white,
                        bgColor: AppColors.mainColor,
                        fontSize: AppSizes.mainButtonText,
                        fontWeight: FontWeight.w400,
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (isChecked) {
                              context.read<AuthenticationCubit>().phoneNumberChanged(_text);
                              await context.read<AuthenticationCubit>().sendOtp();
                              Future.delayed(Duration.zero, () {
                                isPhoneNumberSent = true;
                              });
                            }
                            final preferences = await SharedPreferences.getInstance();
                            await preferences.setString('phone', _text);
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
