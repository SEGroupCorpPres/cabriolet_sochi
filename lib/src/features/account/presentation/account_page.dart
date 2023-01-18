import 'dart:io';

import 'package:cabriolet_sochi/app/bloc/app_bloc.dart';
import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:cabriolet_sochi/src/features/cart/presentation/cart_history_page.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/pages/home.dart';
import 'package:cabriolet_sochi/src/features/orders/presentation/confirm_order.dart';
import 'package:cabriolet_sochi/src/utils/widgets/acccount_menu_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AccountButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            Platform.isIOS
                ? CupertinoPageRoute(
                    builder: (_) => const HomePage(),
                  )
                : MaterialPageRoute(
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
                  ? CupertinoPageRoute(
                      builder: (_) => const SignUpScreen(),
                    )
                  : MaterialPageRoute(
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
      body: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20).r,
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/profile/sulaymon.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(60).r,
                  ),
                ),
                Align(
                  child: Text(
                    'Sulaymon O`rinov',
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
                      '+998999666886',
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
                  padding: const EdgeInsets.only(top: 10.0).r,
                  child: AccountMenuButton(
                    title: 'История заказов',
                    widget: _menuIconButton(
                      () => Navigator.of(context).push(
                        Platform.isIOS
                            ? CupertinoPageRoute(
                                builder: (_) => const CartHistoryPage(),
                              )
                            : MaterialPageRoute(
                                builder: (_) => const CartHistoryPage(),
                              ),
                      ),
                    ),
                  ),
                ),
                AccountMenuButton(
                  title: 'Оплатить заказ',
                  widget: _menuIconButton(
                    () => Navigator.of(context).push(
                      Platform.isIOS
                          ? CupertinoPageRoute(
                              builder: (_) => const ConfirmOrderPage(),
                            )
                          : MaterialPageRoute(
                              builder: (_) => const ConfirmOrderPage(),
                            ),
                    ),
                  ),
                ),
                AccountMenuButton(
                  title: 'Правила и условия',
                  widget: _menuIconButton(() => null),
                ),
                AccountMenuButton(
                  title: 'Поддержка',
                  widget: _menuIconButton(() => null),
                ),
                AccountMenuButton(
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
                GestureDetector(
                  // onTap: () => context.read<AppBloc>().add(const AppLogoutRequested()),
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _menuIconButton(Function() onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        Icons.arrow_forward_ios,
        size: 18.r,
        color: Colors.grey,
      ),
    );
  }
}
