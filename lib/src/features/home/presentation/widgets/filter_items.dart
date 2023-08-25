import 'package:cabriolet_sochi/src/constants/sizes.dart';
import 'package:cabriolet_sochi/src/features/home/data/models/filter_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterItemsList extends StatefulWidget {
  final List<String?>? selectingFilterValue;
  const FilterItemsList({super.key, this.selectingFilterValue});

  @override
  State<FilterItemsList> createState() => _FilterItemsListState();
}

class _FilterItemsListState extends State<FilterItemsList> {
  late List<String?>? selectingFilterValue = widget.selectingFilterValue;
  List<FilterItems> filterItems = FilterItems.filterItems;
  late bool isSelect = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: filterItems.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          setState(() {
            // context.read<FilterBloc>().add(UpdatedFilter(filter: filter[index].copyWith(value: !filter[index].value)));
            filterItems[index].isSelected = !filterItems[index].isSelected;
            if (filterItems[index].isSelected) {
              selectingFilterValue!.add(
                filterItems[index].name,
              );
            } else if (filterItems[index].isSelected == false) {
              selectingFilterValue?.removeWhere((element) => element == filterItems[index].name);
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: filterItems[index].isSelected ? const Color(0xff626262) : Colors.transparent,
            borderRadius: BorderRadius.circular(11).r,
          ),
          width: 250.w,
          height: 35.h,
          padding: const EdgeInsets.symmetric(horizontal: 10).r,
          margin: const EdgeInsets.symmetric(vertical: 1).r,
          child: Row(
            children: [
              Image.asset(
                filterItems[index].imgSrc,
                fit: BoxFit.contain,
                width: 45.w,
                height: 30.h,
              ),
              SizedBox(width: 30.w),
              Text(
                filterItems[index].name.toUpperCase(),
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: AppSizes.productDesc,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
