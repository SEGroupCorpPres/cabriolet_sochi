import 'package:cabriolet_sochi/app/bloc/app_bloc.dart';
import 'package:cabriolet_sochi/routing/app_routes.dart';
import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/features/authentication/bloc/authentication_cubit.dart';
import 'package:cabriolet_sochi/src/features/authentication/presentation/authentication_screen.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/pages/home.dart';
import 'package:cabriolet_sochi/src/features/home/presentation/pages/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          themeMode: ThemeMode.light,
          theme: ThemeData(
            primarySwatch: AppColors.mainColor,
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
      child: const BlocNavigate(),
    );
  }
}

class BlocNavigate extends StatelessWidget {
  const BlocNavigate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const HomePage();
        } else if (state is UnAuthenticated) {
          return const AuthenticationScreen();
        } else {
          return SplashScreen();
        }
      },
    );
  }
}
