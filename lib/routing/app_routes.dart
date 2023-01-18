import 'dart:io';

import 'package:cabriolet_sochi/src/features/home/presentation/pages/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case '/privacy_policy':
      //   return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());
      // case '/terms_and_conditions':
      //   return MaterialPageRoute(
      //       builder: (_) => const TermsAndConditionsScreen());
      case '/home':
        return Platform.isIOS ? CupertinoPageRoute(builder: (_) => const HomePage()) : MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            backgroundColor: Colors.red,
          ),
        );
    }
  }
}
