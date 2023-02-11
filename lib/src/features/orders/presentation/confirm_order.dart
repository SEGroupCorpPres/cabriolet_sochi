import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/account/presentation/account_page.dart';
import 'package:cabriolet_sochi/src/features/checkout/presentation/successful_checkout.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_page_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/main_text_form_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ConfirmOrderPage extends StatefulWidget {
  const ConfirmOrderPage({super.key});

  @override
  State<ConfirmOrderPage> createState() => _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<ConfirmOrderPage> {
  late TextEditingController address1TextEditingController;
  late TextEditingController address2TextEditingController;
  late TextEditingController date1TextEditingController;
  late TextEditingController date2TextEditingController;
  late TextEditingController time1TextEditingController;
  late TextEditingController time2TextEditingController;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AccountButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.adaptive.arrow_back,
        ),
        automaticallyImplyLeading: true,
        title: AppBarTitle(
          title: 'Оформление заказа',
          color: AppColors.mainColor,
          fontSize: AppSizes.title,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5).r,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Container(
                  width: 70.r,
                  height: 70.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10).r,
                    color: Colors.black,
                    image: const DecorationImage(
                      image: AssetImage('assets/images/home_list/aston_martin.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                title: Text(
                  'Mercedes AMG GT S',
                  style: GoogleFonts.montserrat(
                    fontSize: AppSizes.productName,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textColor,
                  ),
                ),
                subtitle: Text(
                  '557 л.с. 2021г.в. синий',
                  style: GoogleFonts.montserrat(
                    fontSize: AppSizes.productName,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 5, top: 10, right: 25).r,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 20).r,
                        child: Text(
                          'Дата и время начала аренды *',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.fieldText,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: MainTextFormField(
                              textEditingController: date1TextEditingController,
                              horizontalPadding: 10,
                              label: '',
                              labelFontSize: AppSizes.mainButtonText,
                              labelColor: AppColors.textColor,
                              marginContainer: 0,
                              width: 200,
                              height: 40,
                              bgColor: AppColors.secondColor,
                              borderR: 10,
                              keyboardType: TextInputType.datetime,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: '23/01/2023',
                              icon: 'assets/icons/pay/calendar.svg',
                              contentPaddingHorizontal: 10,
                              validator: (String? value) {
                                return (value != null) ? 'Do not use the @ char.' : null;
                              },
                              onSaved: (String? value) {},
                              onChanged: (String? value) {},
                            ),
                          ),
                          Flexible(
                            child: MainTextFormField(
                              textEditingController: time1TextEditingController,
                              horizontalPadding: 10,
                              label: '',
                              labelFontSize: AppSizes.mainButtonText,
                              labelColor: AppColors.textColor,
                              marginContainer: 0,
                              width: 200,
                              height: 40,
                              bgColor: AppColors.secondColor,
                              borderR: 10,
                              keyboardType: TextInputType.datetime,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: '12:00',
                              icon: 'assets/icons/pay/timer.svg',
                              contentPaddingHorizontal: 10,
                              validator: (String? value) {
                                return (value != null) ? 'Do not use the @ char.' : null;
                              },
                              onSaved: (String? value) {},
                              onChanged: (String? value) {},
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 20).r,
                        child: Text(
                          'Дата и время окончания аренды *',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.fieldText,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: MainTextFormField(
                              textEditingController: date2TextEditingController,
                              horizontalPadding: 10,
                              label: '',
                              labelFontSize: AppSizes.mainButtonText,
                              labelColor: AppColors.textColor,
                              marginContainer: 0,
                              width: 200,
                              height: 40,
                              bgColor: AppColors.secondColor,
                              borderR: 10,
                              keyboardType: TextInputType.datetime,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: '23/01/2023',
                              icon: 'assets/icons/pay/calendar.svg',
                              contentPaddingHorizontal: 10,
                              validator: (String? value) {
                                return (value != null) ? 'Do not use the @ char.' : null;
                              },
                              onSaved: (String? value) {},
                              onChanged: (String? value) {},
                            ),
                          ),
                          Flexible(
                            child: MainTextFormField(
                              textEditingController: time2TextEditingController,
                              horizontalPadding: 10,
                              label: '',
                              labelFontSize: AppSizes.mainButtonText,
                              labelColor: AppColors.textColor,
                              marginContainer: 0,
                              width: 200,
                              height: 40,
                              bgColor: AppColors.secondColor,
                              borderR: 10,
                              keyboardType: TextInputType.datetime,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10).r,
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: '12:00',
                              icon: 'assets/icons/pay/timer.svg',
                              contentPaddingHorizontal: 10,
                              validator: (String? value) {
                                return (value != null) ? 'Do not use the @ char.' : null;
                              },
                              onSaved: (String? value) {},
                              onChanged: (String? value) {},
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 20).r,
                        child: Text(
                          'Адрес подачи (если требуется)',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.fieldText,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      MainTextFormField(
                        textEditingController: address1TextEditingController,
                        horizontalPadding: 10,
                        label: '',
                        labelFontSize: AppSizes.mainButtonText,
                        labelColor: AppColors.textColor,
                        marginContainer: 0,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        bgColor: AppColors.secondColor,
                        borderR: 10,
                        keyboardType: TextInputType.datetime,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10).r,
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        contentPaddingHorizontal: 10,
                        validator: (String? value) {
                          return (value != null) ? 'Do not use the @ char.' : null;
                        },
                        onSaved: (String? value) {},
                        onChanged: (String? value) {},
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 20).r,
                        child: Text(
                          'Адрес возврата',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.fieldText,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textColor,
                          ),
                        ),
                      ),
                      MainTextFormField(
                        textEditingController: address2TextEditingController,
                        horizontalPadding: 10,
                        label: '',
                        labelFontSize: AppSizes.mainButtonText,
                        labelColor: AppColors.textColor,
                        marginContainer: 0,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        bgColor: AppColors.secondColor,
                        borderR: 10,
                        keyboardType: TextInputType.datetime,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10).r,
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        contentPaddingHorizontal: 10,
                        validator: (String? value) {
                          return (value != null) ? 'Do not use the @ char.' : null;
                        },
                        onSaved: (String? value) {},
                        onChanged: (String? value) {},
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30).r,
                child: MainButton(
                  title: 'Забронировать авто',
                  borderWidth: 0,
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  borderColor: Colors.transparent,
                  titleColor: Colors.white,
                  bgColor: AppColors.mainColor,
                  fontSize: AppSizes.mainButtonText,
                  fontWeight: FontWeight.w400,
                  onTap: () => Navigator.of(context).push(
                    Platform.isIOS
                        ? CupertinoPageRoute(
                            builder: (_) => const SuccessfulCheckoutScreen(),
                          )
                        : MaterialPageRoute(
                            builder: (_) => const SuccessfulCheckoutScreen(),
                          ),
                  ),
                  borderRadius: 8,
                  widget: null,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AccountPageButton(
        onTap: () => Navigator.of(context).push(
          Platform.isIOS
              ? CupertinoPageRoute(
                  builder: (_) => const AccountPage(),
                )
              : MaterialPageRoute(
                  builder: (_) => const AccountPage(),
                ),
        ),
      ),
    );
  }
}
