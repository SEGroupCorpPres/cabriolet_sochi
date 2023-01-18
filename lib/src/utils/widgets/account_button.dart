import 'package:flutter/material.dart';

class AccountButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;

  const AccountButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: Colors.black,
      ),
    );
  }
}
