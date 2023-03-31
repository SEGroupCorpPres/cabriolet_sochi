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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../../utils/widgets/app_textfield.dart';

class AuthenticationConfirm extends StatefulWidget {
  const AuthenticationConfirm({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  State<AuthenticationConfirm> createState() => _AuthenticationConfirmState();
}

class _AuthenticationConfirmState extends State<AuthenticationConfirm> {
  CountdownController countdownController = CountdownController();

  TextEditingController textEditingController = TextEditingController();
  final focusNode1 = FocusNode();
  final focusNode2 = FocusNode();
  final focusNode3 = FocusNode();
  final focusNode4 = FocusNode();
  final focusNode5 = FocusNode();
  final focusNode6 = FocusNode();
  late String _code = '';
  String signature = '{{ app signature }}';
  late String? uid;
  Timer? _timer;
  int _secondsCount = 59;
  int _minuteCount = 1;
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
  }

  Future<void> _getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid');
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
    // cancel();
    // unregisterListener();
  }

  @override
  Widget build(BuildContext context) {
    _getUserID();
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
      body: BlocConsumer<AuthenticationCubit, AuthenticationState>(listener: (context, state) {
        // TODO: implement listener
        Future.delayed(Duration.zero, _getUserID);
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
        if (state.status == AuthenticationStatus.authenticated) {
          if (kDebugMode) {
            print(state);
          }
          if (uid != null && uid!.isNotEmpty) {
            if (kDebugMode) {
              print('user Id: $uid');
            }
            Navigator.of(context).push(
              Platform.isIOS
                  ? CupertinoPageRoute<void>(
                      builder: (_) => const AccountPage(),
                    )
                  : MaterialPageRoute<void>(
                      builder: (_) => const AccountPage(),
                    ),
            );
          } else {
            Navigator.of(context).push(
              Platform.isIOS
                  ? CupertinoPageRoute<void>(
                      builder: (_) => const SignUpScreen(),
                    )
                  : MaterialPageRoute<void>(
                      builder: (_) => const SignUpScreen(),
                    ),
            );
          }
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
          if (uid != null && uid!.isNotEmpty) {
            if (kDebugMode) {
              print('user Id: $uid');
            }
            Navigator.of(context).push(
              Platform.isIOS
                  ? CupertinoPageRoute<void>(
                      builder: (_) => const AccountPage(),
                    )
                  : MaterialPageRoute<void>(
                      builder: (_) => const AccountPage(),
                    ),
            );
          } else {
            Navigator.of(context).push(
              Platform.isIOS
                  ? CupertinoPageRoute<void>(
                      builder: (_) => const SignUpScreen(),
                    )
                  : MaterialPageRoute<void>(
                      builder: (_) => const SignUpScreen(),
                    ),
            );
          }
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
      }, builder: (context, state) {
        return Padding(
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
              _buildInput(context),
              SizedBox(height: 10.h),
              Center(
                child: Column(
                  children: [
                    Visibility(
                      visible: _minuteCount == 0 && _secondsCount == 0 ? false : true,
                      child: Text(
                        textAlign: TextAlign.center,
                        'Вы можете повторно отправить OTP-код по истечении времени \n ${_secondsCount > 9 ? '${_minuteCount.toString()} : ${_secondsCount.toString()}' : '$_minuteCount : 0$_secondsCount'}',
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: AppSizes.mainLabel,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _minuteCount == 0 && _secondsCount == 0 ? true : false,
                      child: TextButton(
                        onPressed: () {
                          context.read<AuthenticationCubit>().phoneNumberChanged(widget.phoneNumber!);
                          context.read<AuthenticationCubit>().sendOtp();
                        },
                        child: Text(
                          'Отправить код повторно',
                          style: GoogleFonts.montserrat(fontSize: AppSizes.fieldText),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Row _buildInput(BuildContext context) {
    return Row(
      children: [
        _getPinField(
          context: context,
          key: '1',
          focusNode: focusNode1,
        ),
        const SizedBox(width: 5),
        _getPinField(
          context: context,
          key: '2',
          focusNode: focusNode2,
        ),
        const SizedBox(width: 5),
        _getPinField(
          context: context,
          key: '3',
          focusNode: focusNode3,
        ),
        const SizedBox(width: 5),
        _getPinField(
          context: context,
          key: '4',
          focusNode: focusNode4,
        ),
        const SizedBox(width: 5),
        _getPinField(
          context: context,
          key: '5',
          focusNode: focusNode5,
        ),
        const SizedBox(width: 5),
        _getPinField(
          context: context,
          key: '6',
          focusNode: focusNode6,
        ),
      ],
    );
  }

  Expanded _getPinField({
    required BuildContext context,
    required String key,
    required FocusNode focusNode,
  }) {
    return Expanded(
      child: AppTextField(
        focusNode: focusNode,
        key: Key(key),
        inputType: TextInputType.number,

        textAlign: TextAlign.center,
        fontSize: 30.h,


      // maxLength: 1,
        onChanged: (txt) {
          _code += txt;
          _code.trim();
          if (txt.length == 1) {
            switch (_code.length) {
              case 1:
                FocusScope.of(context).requestFocus(focusNode2);
                break;
              case 2:
                FocusScope.of(context).requestFocus(focusNode3);
                break;
              case 3:
                FocusScope.of(context).requestFocus(focusNode4);
                break;
              case 4:
                FocusScope.of(context).requestFocus(focusNode5);
                break;
              case 5:
                FocusScope.of(context).requestFocus(focusNode6);
                break;
              case 6:
                context.read<AuthenticationCubit>().otpChanged(_code);
                FocusScope.of(context).unfocus();
                countdownController.pause();
                context.read<AuthenticationCubit>().verifyPhoneNumber();
                break;
            }
          }
        },
      ),
    );
  }
}
