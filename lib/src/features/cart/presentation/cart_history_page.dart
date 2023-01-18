import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/utils/widgets/account_button.dart';
import 'package:cabriolet_sochi/src/utils/widgets/app_bar_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class CartHistoryPage extends StatefulWidget {
  const CartHistoryPage({super.key});

  @override
  State<CartHistoryPage> createState() => _CartHistoryPageState();
}

class _CartHistoryPageState extends State<CartHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
      body: Padding(
        padding: const EdgeInsets.all(20.0).r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
      ),
      // body: Padding(
      //   padding: const EdgeInsets.all(10).r,
      //   child: SingleChildScrollView(
      //     scrollDirection: Axis.vertical,
      //     child: Column(
      //       children: [
      //         Card(
      //           margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10).r,
      //           elevation: 0,
      //           shape: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(8).r,
      //             borderSide: BorderSide(
      //               color: Colors.lightGreen.withOpacity(0.15),
      //               width: 2,
      //             ),
      //           ),
      //           color: AppColors.secondColor,
      //           child: Padding(
      //             padding: const EdgeInsets.all(10.0).r,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(vertical: 4.0).r,
      //                       child: Text(
      //                         'Номер заказа 1982',
      //                         style: GoogleFonts.montserrat(
      //                           fontSize: AppSizes.mainLabel,
      //                           color: Colors.grey,
      //                           fontWeight: FontWeight.w500,
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(vertical: 4.0).r,
      //                       child: Row(
      //                         children: [
      //                           SvgPicture.asset(
      //                             'assets/icons/history/car_icon.svg',
      //                             height: 13.r,
      //                             width: 13.r,
      //                             fit: BoxFit.cover,
      //                           ),
      //                           SizedBox(width: 10.w),
      //                           Text(
      //                             'Ford Mustang 2019',
      //                             style: GoogleFonts.montserrat(
      //                               fontSize: AppSizes.mainButtonText,
      //                               color: AppColors.textColor,
      //                               fontWeight: FontWeight.w400,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(vertical: 4.0).r,
      //                       child: Row(
      //                         children: [
      //                           SvgPicture.asset(
      //                             'assets/icons/history/clarity_date_line.svg',
      //                             height: 17.r,
      //                             width: 17.r,
      //                             fit: BoxFit.cover,
      //                           ),
      //                           SizedBox(width: 10.w),
      //                           Text(
      //                             '01.01.2023',
      //                             style: GoogleFonts.montserrat(
      //                               fontSize: AppSizes.mainButtonText,
      //                               color: AppColors.textColor,
      //                               fontWeight: FontWeight.w400,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Text(
      //                   '22 250 ₽',
      //                   style: GoogleFonts.montserrat(
      //                     fontWeight: FontWeight.w800,
      //                     fontSize: AppSizes.cartHistoryProductCost,
      //                     color: AppColors.textColor,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         Card(
      //           margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 10).r,
      //           elevation: 0,
      //           shape: OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(8).r,
      //             borderSide: BorderSide(
      //               color: Colors.lightGreen.withOpacity(0.15),
      //               width: 2,
      //             ),
      //           ),
      //           color: AppColors.secondColor,
      //           child: Padding(
      //             padding: const EdgeInsets.all(10.0).r,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //                 Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(vertical: 4.0).r,
      //                       child: Text(
      //                         'Номер заказа 1784',
      //                         style: GoogleFonts.montserrat(
      //                           fontSize: AppSizes.mainLabel,
      //                           color: Colors.grey,
      //                           fontWeight: FontWeight.w500,
      //                         ),
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(vertical: 4.0).r,
      //                       child: Row(
      //                         children: [
      //                           SvgPicture.asset(
      //                             'assets/icons/history/car_icon.svg',
      //                             height: 13.r,
      //                             width: 13.r,
      //                             fit: BoxFit.cover,
      //                           ),
      //                           const SizedBox(width: 10),
      //                           Text(
      //                             'Porsche Boxster',
      //                             style: GoogleFonts.montserrat(
      //                               fontSize: AppSizes.mainButtonText,
      //                               color: AppColors.textColor,
      //                               fontWeight: FontWeight.w400,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(vertical: 4.0).r,
      //                       child: Row(
      //                         children: [
      //                           SvgPicture.asset(
      //                             'assets/icons/history/clarity_date_line.svg',
      //                             height: 17.r,
      //                             width: 17.r,
      //                             fit: BoxFit.cover,
      //                           ),
      //                           SizedBox(width: 10.w),
      //                           Text(
      //                             '31.12.2022',
      //                             style: GoogleFonts.montserrat(
      //                               fontSize: AppSizes.mainButtonText,
      //                               color: AppColors.textColor,
      //                               fontWeight: FontWeight.w400,
      //                             ),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 Text(
      //                   '65 000 ₽',
      //                   style: GoogleFonts.montserrat(
      //                     fontWeight: FontWeight.w800,
      //                     fontSize: AppSizes.cartHistoryProductCost,
      //                     color: AppColors.textColor,
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
