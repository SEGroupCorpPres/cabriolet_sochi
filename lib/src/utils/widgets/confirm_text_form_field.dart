import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPFields extends StatefulWidget {
  const OTPFields({super.key, required this.otpCode});
  final String otpCode;

  @override
  State<OTPFields> createState() => _OTPFieldsState();
}

class _OTPFieldsState extends State<OTPFields> {
  late TextEditingController codeController1;
  late TextEditingController codeController2;
  late TextEditingController codeController3;
  late TextEditingController codeController4;
  late TextEditingController codeController5;
  late TextEditingController codeController6;

  FocusNode? pin2FN;
  FocusNode? pin3FN;
  FocusNode? pin4FN;
  FocusNode? pin5FN;
  FocusNode? pin6FN;
  final pinStyle = GoogleFonts.montserrat(
    fontSize: 40.sp,
    fontWeight: FontWeight.w800,
  );

  @override
  void initState() {
    codeController1 = TextEditingController();
    codeController2 = TextEditingController();
    codeController3 = TextEditingController();
    codeController4 = TextEditingController();
    codeController5 = TextEditingController();
    codeController6 = TextEditingController();
    super.initState();
    pin2FN = FocusNode();
    pin3FN = FocusNode();
    pin4FN = FocusNode();
    pin5FN = FocusNode();
    pin6FN = FocusNode();
  }

  @override
  void dispose() {
    codeController1.dispose();
    codeController2.dispose();
    codeController3.dispose();
    codeController4.dispose();
    codeController5.dispose();
    codeController6.dispose();
    super.dispose();
    pin2FN?.dispose();
    pin3FN?.dispose();
    pin4FN?.dispose();
    pin5FN?.dispose();
    pin6FN?.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 60.w,
                child: TextFormField(
                  controller: codeController1,
                  autofocus: true,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    nextField(value, pin2FN);
                  },
                ),
              ),
              SizedBox(
                width: 60.w,
                child: TextFormField(
                  controller: codeController2,
                  focusNode: pin2FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) => nextField(value, pin3FN),
                ),
              ),
              SizedBox(
                width: 60.w,
                child: TextFormField(
                  controller: codeController3,
                  focusNode: pin3FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) => nextField(value, pin4FN),
                ),
              ),
              SizedBox(
                width: 60.w,
                child: TextFormField(
                  controller: codeController4,
                  focusNode: pin3FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) => nextField(value, pin5FN),
                ),
              ),
              SizedBox(
                width: 60.w,
                child: TextFormField(
                  controller: codeController5,
                  focusNode: pin3FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) => nextField(value, pin6FN),
                ),
              ),
              SizedBox(
                width: 60.w,
                child: TextFormField(
                  controller: codeController6,
                  focusNode: pin4FN,
                  style: pinStyle,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin6FN!.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  String get _otpCode => codeController1.text + codeController2.text + codeController3.text + codeController4.text + codeController5.text + codeController6.text;
}
