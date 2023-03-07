import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/cart/bloc/cart_bloc.dart';
import 'package:cabriolet_sochi/src/features/cart/data/models/cart_model.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CartHistoryPage extends StatefulWidget {
  const CartHistoryPage({super.key});

  @override
  State<CartHistoryPage> createState() => _CartHistoryPageState();
}

class _CartHistoryPageState extends State<CartHistoryPage> {
  final _uid = FirebaseAuth.instance.currentUser!.uid;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  List cartListUid = [];
  List cartList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CartBloc>(context).add(GetData());
    // getCartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AccountButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icons.adaptive.arrow_back,
        ),
        title: AppBarTitle(
          title: 'История заказов',
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: AppSizes.cartHistoryProductCost,
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartDataLoading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (state is CartDataLoaded) {
            if (state.cartData.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(20).r,
                child: Column(
                  children: [
                    SizedBox(height: 100.h),
                    Container(
                      width: ScreenUtil().screenWidth,
                      height: ScreenUtil().screenHeight * 0.4,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/history/splash.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      'Упс, Вы пока не оформляли аренду',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textColor,
                        fontSize: AppSizes.fieldText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            } else {
              cartList = state.cartData;
              print('list -----> ${cartList.toList()}');
              print('data');
              return Padding(
                padding: const EdgeInsets.all(10).r,
                child: ListView.builder(
                  itemCount: cartList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10).r,
                      elevation: 0,
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8).r,
                        borderSide: BorderSide(
                          color: Colors.lightGreen.withOpacity(0.15),
                          width: 2,
                        ),
                      ),
                      color: AppColors.secondColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10).r,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4).r,
                                  child: Text(
                                    'Номер заказа ${cartList[index]['id']}',
                                    style: GoogleFonts.montserrat(
                                      fontSize: AppSizes.mainLabel,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4).r,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/history/car_icon.svg',
                                        height: 13.r,
                                        width: 13.r,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        '${cartList[index]['carName']}',
                                        style: GoogleFonts.montserrat(
                                          fontSize: AppSizes.mainButtonText,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4).r,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/history/clarity_date_line.svg',
                                        height: 17.r,
                                        width: 17.r,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        _dateFormat.format((cartList[index]['rentalEndDate'] as Timestamp).toDate()),
                                        style: GoogleFonts.montserrat(
                                          fontSize: AppSizes.mainButtonText,
                                          color: AppColors.textColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${cartList[index]['rentalPrice']} ₽',
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w800,
                                fontSize: AppSizes.cartHistoryProductCost,
                                color: AppColors.textColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          } else {
            return Padding(
              padding: const EdgeInsets.all(20).r,
              child: Column(
                children: [
                  SizedBox(height: 100.h),
                  Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight * 0.4,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/history/splash.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'Упс, Вы пока не оформляли аренду',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400,
                      color: AppColors.textColor,
                      fontSize: AppSizes.fieldText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
