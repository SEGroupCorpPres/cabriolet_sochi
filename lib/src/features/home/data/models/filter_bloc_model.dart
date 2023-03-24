import 'package:cabriolet_sochi/src/features/home/data/models/filter_model.dart';
import 'package:equatable/equatable.dart';

class FilterBloc extends Equatable {
  const FilterBloc({this.filter = const <Filter>[]});

  final List<Filter> filter;

  FilterBloc copyWith({
    List<Filter>? filter,
  }) =>
      FilterBloc(
        filter: filter ?? this.filter,
      );

  @override
  // TODO: implement props
  List<Object?> get props => [filter];
}
