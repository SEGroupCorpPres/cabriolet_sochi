import 'dart:io';

import 'package:cabriolet_sochi/app/bloc/app_bloc.dart';
import 'package:cabriolet_sochi/routing/app_routes.dart';
import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/authentication_screen.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/sign_up_screen.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  final String? uid;

  const App({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          themeMode: ThemeMode.light,
          theme: ThemeData(
            useMaterial3: true,
            inputDecorationTheme: const InputDecorationTheme(
              outlineBorder: BorderSide(
                color: Colors.red,
              ),
            ),
            primarySwatch: AppColors.mainColor,
            brightness: Brightness.light,
            scaffoldBackgroundColor: AppColors.secondColor,
            appBarTheme: AppBarTheme(
              color: AppColors.secondColor,
              elevation: 0,
              centerTitle: false,
            ),
          ),
          onGenerateRoute: RouteGenerator.generateRoute,
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state is Authenticated) {
            if (uid != null && uid!.isNotEmpty) {
              print('user Id: $uid');
              return const AccountPage();
            } else {
              return const SignUpScreen();
            }
          } else if (state is UnAuthenticated) {
            return const AuthenticationScreen();
          } else {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
