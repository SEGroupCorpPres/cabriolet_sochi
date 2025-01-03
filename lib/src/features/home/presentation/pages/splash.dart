import 'dart:io';
import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/authentication_screen.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  String? uid = '';

  Future<void> _userId() async {
    final preferences = await SharedPreferences.getInstance();
    uid = preferences.getString('uid');
    // print(object)
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _userId();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    if (uid != null) {
      if (uid!.length > 3) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          Navigator.of(context).pushReplacement(
            Platform.isIOS
                ? CupertinoPageRoute<void>(
              builder: (_) => const AccountPage(),
            )
                : MaterialPageRoute<void>(
              builder: (_) => const AccountPage(),
            ),
          );
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/background_gradient.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            SizedBox(
              height: 100.w,
              width: 100.w,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                image: const DecorationImage(
                  image: AssetImage('assets/images/splash/background.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  child: SizedBox(
                    width: 240.w,
                    child: Text(
                      'Аренда кабриолетов г.Сочи',
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: AppSizes.title,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20).r,
                  child: Image.asset(
                    'assets/images/splash/splash_screen.png',
                    fit: BoxFit.fitWidth,
                    scale: 0.5,
                  ),
                ),
                Visibility(
                  visible: uid == null || uid!.isEmpty,
                  child: MainButton(
                    widget: null,
                    title: 'Войти',
                    borderWidth: 0,
                    height: 45,
                    width: 250,
                    borderColor: Colors.transparent,
                    titleColor: const Color(0xffd9d9d9),
                    bgColor: AppColors.mainColor,
                    fontSize: AppSizes.productOverviewTitle,
                    fontWeight: FontWeight.w600,
                    onTap: () => Navigator.of(context).pushAndRemoveUntil<void>(
                      AuthenticationScreen.route(),
                      (route) => true,
                    ),
                    borderRadius: 8,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
