import 'package:cabriolet_sochi/src/features/home/data/models/filter_items.dart';
import 'package:equatable/equatable.dart';

class FilterItemModel extends Equatable {
  const FilterItemModel({required this.id, required this.filterItems, required this.value});

  final int id;
  final FilterItems filterItems;
  final bool value;

  FilterItemModel copyWith({
    int? id,
    FilterItems? filterItems,
    bool? value,
  }) =>
      FilterItemModel(
        id: id ?? this.id,
        filterItems: filterItems ?? this.filterItems,
        value: value ?? this.value,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        filterItems,
        value,
      ];

  static List<FilterItemModel> filter = FilterItems.filterItems
      .map(
        (filterItem) => FilterItemModel(
          id: filterItem.id,
          filterItems: filterItem,
          value: false,
        ),
      )
      .toList();
}
