class Car {
  Car({
    this.id,
    this.images,
    this.name,
    this.model,
    this.carLogo,
    this.description,
    this.year,
    this.color,
    this.personCount,
    this.engineDescription,
    this.output,
    this.fuelDescription,
    this.transmissionDescription,
    this.dimensions,
    this.rentalPrice,
    this.deposit,
    this.termsOfLease,
    this.package,
  });

  Car.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    images = json['images'] != null ? json['images'] as List<String> : [];
    name = json['name'] as String;
    model = json['model'] as String;
    carLogo = json['car_logo'] as String;
    description = json['description'] as String;
    year = json['year'] as int;
    color = json['color'] as String;
    personCount = json['person_count'] as int;
    engineDescription = json['engine_description'] as String;
    output = json['output'] as int;
    fuelDescription = json['fuel_description'] as String;
    transmissionDescription = json['transmission_description'] as String;
    dimensions = json['dimensions'] as String;
    rentalPrice = json['rental_price'] as int;
    deposit = json['deposit'] as int;
    termsOfLease = json['terms_of_lease'] as String;
    package = json['package'] as String;
  }

  int? id;
  List<String>? images;
  String? name;
  String? model;
  String? carLogo;
  String? description;
  int? year;
  String? color;
  int? personCount;
  String? engineDescription;
  int? output;
  String? fuelDescription;
  String? transmissionDescription;
  String? dimensions;
  int? rentalPrice;
  int? deposit;
  String? termsOfLease;
  String? package;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['images'] = images;
    map['name'] = name;
    map['model'] = model;
    map['car_logo'] = carLogo;
    map['description'] = description;
    map['year'] = year;
    map['color'] = color;
    map['person_count'] = personCount;
    map['engine_description'] = engineDescription;
    map['output'] = output;
    map['fuel_description'] = fuelDescription;
    map['transmission_description'] = transmissionDescription;
    map['dimensions'] = dimensions;
    map['rental_price'] = rentalPrice;
    map['deposit'] = deposit;
    map['terms_of_lease'] = termsOfLease;
    map['package'] = package;
    return map;
  }
}
