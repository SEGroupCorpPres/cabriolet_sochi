import 'dart:io';

import 'package:cabriolet_sochi/app/bloc/app_bloc.dart';
import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/bloc/account_bloc.dart';
import 'package:cabriolet_sochi/src/features/account/domain/repositories/account_repository.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:cabriolet_sochi/src/features/cart/presentation/cart_history_page.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/pages/home.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/pages/splash.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_menu_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late bool isFirstTimeEntry = false;
  late bool isChecked = false;
  Map<String, dynamic> user = {};
  final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final preferences = SharedPreferences.getInstance();
  final Uri _url = Uri.parse('https://cabrioletsochi.ru/usloviya-i-tseny.html');
  final Uri _paymentUrl = Uri.parse('https://cabrioletsochi.ru/oplata-cabrio-online.html');
  final Uri _contactUrl = Uri.parse('https://cabrioletsochi.ru/kontakty.html');

  Future<void> getIsFirstTimeEntry() async {
    final preferences = await SharedPreferences.getInstance();
    isFirstTimeEntry = preferences.getBool('isFirstTimeEntry') ?? false;
    await preferences.setBool('isFirstTimeEntry', true);
  }

  Future<void> clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', '');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AccountBloc>(context).add(GetData());
    if (isFirstTimeEntry) {
      getIsFirstTimeEntry();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldState = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        leading: AccountButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            Platform.isIOS
                ? CupertinoPageRoute<void>(
                    builder: (_) => const HomePage(),
                  )
                : MaterialPageRoute<void>(
                    builder: (_) => const HomePage(),
                  ),
          ),
          icon: Icons.adaptive.arrow_back,
        ),
        title: AppBarTitle(
          title: 'Профиль',
          color: Colors.black,
          fontSize: AppSizes.title,
          fontWeight: FontWeight.w800,
        ),
        actions: [
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              Platform.isIOS
                  ? CupertinoPageRoute<void>(
                      builder: (_) => const SignUpScreen(),
                    )
                  : MaterialPageRoute<void>(
                      builder: (_) => const SignUpScreen(),
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 20).r,
              child: SvgPicture.asset(
                'assets/icons/profile/edit.svg',
                width: 15.r,
                height: 15.r,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          print('Account State ---> $state');
          if (state is UserDataLoaded) {
            user = state.userData;
            print(user);
            return Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20).r,
                        width: 100.r,
                        height: 100.r,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(user['imageUrl'].toString()),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(60).r,
                        ),
                      ),
                      Align(
                        child: Text(
                          user['fullName'].toString(),
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: AppSizes.title,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Column(
                        children: [
                          Text(
                            'Телефон',
                            style: GoogleFonts.montserrat(
                              color: AppColors.labelColor,
                              fontSize: AppSizes.mainLabel,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            user['phoneNumber'].toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: AppSizes.mainButtonText,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10).r,
                        child: MaterialButton(
                          onPressed: () => Navigator.of(context).push(
                            Platform.isIOS
                                ? CupertinoPageRoute<void>(
                                    builder: (_) => const CartHistoryPage(),
                                  )
                                : MaterialPageRoute<void>(
                                    builder: (_) => const CartHistoryPage(),
                                  ),
                          ),
                          child: AccountMenuButton(
                            title: 'История заказов',
                            widget: Icon(
                              Icons.arrow_forward_ios,
                              size: 18.r,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async => launchUrl(_paymentUrl),
                        child: AccountMenuButton(
                          title: 'Оплатить заказ',
                          widget: Icon(
                            Icons.arrow_forward_ios,
                            size: 18.r,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async => launchUrl(_url),
                        child: AccountMenuButton(
                          title: 'Правила и условия',
                          widget: Icon(
                            Icons.arrow_forward_ios,
                            size: 18.r,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () async => launchUrl(_contactUrl),
                        child: AccountMenuButton(
                          title: 'Поддержка',
                          widget: Icon(
                            Icons.arrow_forward_ios,
                            size: 18.r,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {},
                        child: AccountMenuButton(
                          title: 'Уведомления',
                          widget: Padding(
                            padding: const EdgeInsets.only(right: 10).r,
                            child: Switch.adaptive(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      BlocBuilder<AppBloc, AppState>(
                        builder: (context, state) {
                          return GestureDetector(
                            onTap: () {
                              context.read<AppBloc>().add(SignOutEvent());
                              clearUserId();
                              Navigator.of(context).pushAndRemoveUntil(
                                  Platform.isIOS
                                      ? CupertinoPageRoute<void>(
                                          builder: (_) => SplashScreen(isFirstTimeEntry: true),
                                        )
                                      : MaterialPageRoute<void>(
                                          builder: (_) => SplashScreen(isFirstTimeEntry: true),
                                        ),
                                  (route) => true);
                            },
                            child: ListTile(
                              title: Text(
                                'Выйти из аккаунта',
                                style: GoogleFonts.montserrat(
                                  color: AppColors.mainColor,
                                  fontSize: AppSizes.mainButtonText,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is UserDataLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
