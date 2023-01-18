import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/authentication_confirm.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../bloc/authentication_cubit.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationCubit(),
      child: Scaffold(
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
                          'Authenticating...',
                          style: GoogleFonts.montserrat(),
                        ),
                        const CircularProgressIndicator.adaptive()
                      ],
                    ),
                  ),
                );
            }
            // if (state.status == AuthenticationStatus.googleAuthenticated) {
            //   ScaffoldMessenger.of(context)
            //     ..hideCurrentSnackBar()
            //     ..showSnackBar(
            //       SnackBar(
            //         backgroundColor: Colors.green,
            //         content: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: const [
            //             Text('Google Authenticated...'),
            //             Icon(Icons.check),
            //           ],
            //         ),
            //       ),
            //     );
            //
            // }

            if (state.status == AuthenticationStatus.otpSent) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('OTP Sent...'),
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
                        Text('OTP Verified successfully...'),
                        Icon(Icons.check),
                      ],
                    ),
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
                        Text('Updating profile...'),
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
                        Text('Profile Updated successfully...'),
                        Icon(Icons.check),
                      ],
                    ),
                  ),
                );
              Navigator.pushReplacementNamed(context, '/home');
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
                        Text(state.error ?? 'Authentication Error'),
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
                  child: MainTextFormField(
                    horizontalPadding: 20,
                    label: 'Номер телефона',
                    labelFontSize: AppSizes.mainLabel,
                    labelColor: AppColors.labelColor,
                    marginContainer: 10,
                    width: MediaQuery.of(context).size.width,
                    height: 32,
                    bgColor: const Color(0xffEBF7EE),
                    borderR: 8,
                    keyboardType: TextInputType.number,
                    border: InputBorder.none,
                    contentPaddingHorizontal: 20,
                    textEditingController: phoneTextEditingController,
                    // validator: (String? value) {
                    //   if (value == null) {
                    //     return 'Область не может быть пустой';
                    //   } else if (value.length - 1 < 11) {
                    //     return 'Номер телефона должен состоять из 11 цифр.';
                    //   }
                    //   return null;
                    // },
                    validator: (value) {},
                    onSaved: (String? value) {},
                    onChanged: (String? value) => context.read<AuthenticationCubit>().phoneNumberChanged(value!),
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
                    height: 40,
                    width: MediaQuery.of(context).size.width,
                    borderColor: Colors.transparent,
                    titleColor: Colors.white,
                    bgColor: AppColors.mainColor,
                    fontSize: AppSizes.mainButtonText,
                    fontWeight: FontWeight.w400,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        if (isChecked) {
                          context.read<AuthenticationCubit>().sendOtp();
                        }
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
      ),
    );
  }
}
