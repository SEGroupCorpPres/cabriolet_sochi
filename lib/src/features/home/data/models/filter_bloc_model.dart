import 'package:cabriolet_sochi/src/features/home/data/models/filter_model.dart';
import 'package:equatable/equatable.dart';

class FilterModel extends Equatable {
  const FilterModel({this.filter = const <FilterItemModel>[]});

  final List<FilterItemModel> filter;

  FilterModel copyWith({
    List<FilterItemModel>? filter,
  }) =>
      FilterModel(
        filter: filter ?? this.filter,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [filter];
}
