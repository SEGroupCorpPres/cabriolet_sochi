import 'dart:io';

import 'package:cabriolet_sochi/src/constants/colors.dart';
import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/home/data/models/car_model.dart';
import 'package:cabriolet_sochi/src/features/products/presentation/product_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class CarList extends StatelessWidget {
  const CarList({super.key, required this.carsModel});
  final List<CarModel> carsModel;

  @override
  Widget build(BuildContext context) {
    return ResponsiveGridList(
      horizontalGridMargin: 20.w,
      horizontalGridSpacing: 30.w,
      verticalGridMargin: 0,
      verticalGridSpacing: 20.h,
      minItemWidth: 140.w,
      children: List.generate(
        carsModel.length,
            (index) => GestureDetector(
          onTap: () => Navigator.of(context).push(
            Platform.isIOS
                ? CupertinoPageRoute<dynamic>(
              builder: (_) => ProductOverview(
                index: index,
              ),
            )
                : MaterialPageRoute<dynamic>(
              builder: (_) => ProductOverview(
                index: index,
              ),
            ),
          ),
          child: Container(
            constraints: const BoxConstraints.expand(),
            // height: 270.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15).r,
              color: AppColors.secondColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Wrap(
              children: [
                Container(
                  width: double.infinity,
                  height: 99.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15).r,
                    image: DecorationImage(
                      image: NetworkImage(
                        carsModel[index].images![0].toString(),
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10).r,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                        child: Text(
                          '${carsModel[index].name!}  ${carsModel[index].model!}',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.productName,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                        child: Text(
                          '${carsModel[index].output!} л.с. ${carsModel[index].year} г.в.',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.productDesc,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                        child: Text(
                          carsModel[index].color!,
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.productName,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2).r,
                        child: Container(
                          height: 20.h,
                          width: 135.w,
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ).r,
                          ),
                          child: Center(
                            child: Text(
                              '${carsModel[index].rentalPrice!} ₽ в сутки',
                              style: GoogleFonts.montserrat(
                                fontSize: AppSizes.fieldText,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1).r,
                        child: Text(
                          'залог ${carsModel[index].deposite} ₽',
                          style: GoogleFonts.montserrat(
                            fontSize: AppSizes.productName,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff6C6C6C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
