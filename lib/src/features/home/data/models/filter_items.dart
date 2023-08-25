import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

/// Model for FilterItems Button
class FilterItems extends Equatable {
  /// constructor for model
  FilterItems( {
    required this.id,
    required this.name,
    required this.imgSrc,
    required this.isSelected,
  });

  /// filterItems item id
  final int id;

  /// car name
  final String name;

  /// car logo
  final String imgSrc;

  /// filterItems item selection
  bool isSelected;

  // list of filterItems values
  static List<FilterItems> filterItems = [
    FilterItems(id: 1, name: 'ASTON MARTIN', imgSrc: 'assets/icons/home_list/filter/logo3.png', isSelected: false),
    FilterItems(id: 2, name: 'BMW', imgSrc: 'assets/icons/home_list/filter/logo4.png', isSelected: false),
    FilterItems(id: 3, name: 'CHEVROLET', imgSrc: 'assets/icons/home_list/filter/logo2.png', isSelected: false),
    FilterItems(id: 4, name: 'DODGE', imgSrc: 'assets/icons/home_list/filter/logo6.png', isSelected: false),
    FilterItems(id: 5, name: 'FORD', imgSrc: 'assets/icons/home_list/filter/logo5.png', isSelected: false),
    FilterItems(id: 6, name: 'MERCEDES', imgSrc: 'assets/icons/home_list/filter/logo0.png', isSelected: false),
    FilterItems(id: 7, name: 'PORSCHE', imgSrc: 'assets/icons/home_list/filter/logo1.png', isSelected: false),
  ];

  @override
  // ignore: flutter_style_todos
  // TODO: implement props
  List<Object?> get props => [id, name, imgSrc];
}
