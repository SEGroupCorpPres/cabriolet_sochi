import 'dart:async';
import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/authentication/bloc/authentication_cubit.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:timer_count_down/timer_controller.dart';

class AuthenticationConfirm extends StatefulWidget {
  const AuthenticationConfirm({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  State<AuthenticationConfirm> createState() => _AuthenticationConfirmState();
}

class _AuthenticationConfirmState extends State<AuthenticationConfirm> {
  CountdownController countdownController = CountdownController();

  TextEditingController textEditingController = TextEditingController();

  late String _code = '';
  String signature = '{{ app signature }}';
  late String? userId;
  Timer? _timer;
  int _secondsCount = 59;
  int _minuteCount = 2;
  bool _timeOf = false;
  final pinStyle = GoogleFonts.montserrat(
    fontSize: 40.sp,
    fontWeight: FontWeight.w800,
  );

  @override
  void initState() {
    countdownController.start();
    super.initState();
    setState(() {});
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _secondsCount -= 1;
        setState(() {});
      },
    );
    _listenSmsCode().then((value) async {
      final preferences = await SharedPreferences.getInstance();
      userId = preferences.getString('userId');
    });
  }

  // Future<String?> _getUserId()async{
  //   final preferences = await SharedPreferences.getInstance();
  //   final userId = preferences.getString('userId');
  //   return userId;
  // }
  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      if (_secondsCount == 0 && _minuteCount != 0) {
        _secondsCount = 59;
        _minuteCount -= 1;
      }
      if (_minuteCount == 0 && _secondsCount == 0) {
        _timer!.cancel();
        _timeOf = true;
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: AccountButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.adaptive.arrow_back,
        ),
        title: AppBarTitle(
          title: 'Вход',
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: AppSizes.cartHistoryProductCost,
        ),
      ),
      body: BlocListener<AuthenticationCubit, AuthenticationState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state.status == AuthenticationStatus.authenticated) {
            if (userId != null || userId!.isNotEmpty) {
              Navigator.of(context).push(
                Platform.isIOS
                    ? CupertinoPageRoute<void>(
                        builder: (_) => AccountPage(),
                      )
                    : MaterialPageRoute<void>(
                        builder: (_) => AccountPage(),
                      ),
              );
            } else {
              Navigator.of(context).push(
                Platform.isIOS
                    ? CupertinoPageRoute<void>(
                        builder: (_) => SignUpScreen(),
                      )
                    : MaterialPageRoute<void>(
                        builder: (_) => SignUpScreen(),
                      ),
              );
            }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                'На номер ${widget.phoneNumber} отправлен код для входа в аккаунт',
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: AppSizes.mainButtonText,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10.h),
              PinFieldAutoFill(
                decoration: UnderlineDecoration(
                  textStyle: GoogleFonts.montserrat(
                    fontSize: 20.sp,
                    color: Colors.black,
                  ),
                  colorBuilder: const FixedColorBuilder(
                    AppColors.mainColor,
                  ),
                ),
                currentCode: _code,
                onCodeChanged: (code) {
                  if (code!.length == 6) {
                    _code = code;
                    countdownController.pause();
                    context.read<AuthenticationCubit>().otpChanged(_code);
                  }
                },
                controller: textEditingController,
                cursor: Cursor(color: AppColors.mainColor),
              ),
              SizedBox(height: 10.h),
              Center(
                child: Column(
                  children: [
                    Visibility(
                      child: Text(
                        _secondsCount > 9 ? '${_minuteCount.toString()} : ${_secondsCount.toString()}' : '$_minuteCount : 0$_secondsCount',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: AppSizes.mainLabel,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (_timeOf) {
                          _timeOf = false;
                          _minuteCount = 2;
                          _secondsCount = 59;
                          _timer = Timer.periodic(
                            const Duration(seconds: 1),
                            (timer) {
                              _secondsCount -= 1;
                              setState(() {});
                            },
                          );
                        }
                        if (_minuteCount == 0 && _secondsCount == 0) {
                          context.read<AuthenticationCubit>().sendOtp();
                        }
                      },
                      child: Text(
                        'Отправить код повторно',
                        style: GoogleFonts.montserrat(fontSize: AppSizes.fieldText),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _listenSmsCode() async {
    await SmsAutoFill().listenForCode();
  }
}
