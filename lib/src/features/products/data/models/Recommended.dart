class Recommended {
  Recommended({
    this.id,
    this.image,
    this.name,
    this.model,
    this.description,
    this.color,
    this.rentalPrice,
    this.deposit,
  });

  Recommended.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    image = json['image'] as String;
    name = json['name'] as String;
    model = json['model'] as String;
    description = json['description'] as String;
    color = json['color'] as String;
    rentalPrice = json['rental_price'] as int;
    deposit = json['deposit'] as int;
  }

  int? id;
  String? image;
  String? name;
  String? model;
  String? description;
  String? color;
  int? rentalPrice;
  int? deposit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    map['name'] = name;
    map['model'] = model;
    map['description'] = description;
    map['color'] = color;
    map['rental_price'] = rentalPrice;
    map['deposit'] = deposit;
    return map;
  }
}
