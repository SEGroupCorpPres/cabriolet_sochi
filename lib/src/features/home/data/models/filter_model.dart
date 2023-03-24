import 'package:cabriolet_sochi/src/features/home/data/models/filter_items.dart';
import 'package:equatable/equatable.dart';

class Filter extends Equatable {
  const Filter({required this.id, required this.filterItems, required this.value});

  final int id;
  final FilterItems filterItems;
  final bool value;

  Filter copyWith({
    int? id,
    FilterItems? filterItems,
    bool? value,
  }) =>
      Filter(
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

  static List<Filter> filter = FilterItems.filterItems
      .map(
        (filterItem) => Filter(
          id: filterItem.id,
          filterItems: filterItem,
          value: false,
        ),
      )
      .toList();
}
