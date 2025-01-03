import 'package:cloud_firestore/cloud_firestore.dart';

/// id : 1
/// images : ["https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi.jpg.webp","https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi-4-1536x1152.jpg.webp","https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi-5-1536x1024.jpeg.webp","https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi-2-1536x1153.jpg.webp","https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi-7.jpg.webp","https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi-6.jpg.webp","https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi-3.jpg.webp","https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi-9.jpg.webp","https://cabrioletsochi.ru/wp-content/webp-express/webp-images/uploads/2022/06/arenda-aston-martin-v-sochi-8.jpg.webp"]
/// name : "Aston Martin"
/// model : "DB11"
/// car_logo : "https://cabrioletsochi.ru/wp-content/themes/CabrioletSochi/assets/images/Aston-Martin.png"
/// description : "DB11 2019 г.в."
/// year : 2019
/// color : "black"
/// person_count : 2
/// engine_description : "Двигатель 4.0 л, 8 цилиндров, Мощность 510 л.с. ,Сн. масса 1760 кг"
/// output : 510
/// fuel_description : "Объем т. бака 78 л,Бензин Аи-98"
/// transmission_description : "8-ст. АКПП,задний привод"
/// dimensions : "Длина = 4739 мм, Ширина = 1940 мм, Высота = 1279 мм, Клиренс = 80 мм"
/// rental_price : 80000
/// deposit : 120000
/// terms_of_lease : "Внимание! Для аренды спортивного купе Aston Martin DB11 имеются ограничения: минимальный допустимый возраст арендатора — 27 лет, минимальный допустимый стаж вождения арендатора — 5 лет "
/// package: : "круговая система обзора, камера 360. автоматическая система парковки. крепеж ISOFIX для детских сидений. кузов из алюминиевого сплава, литые дверные каркасы из магниевого сплава. углепластиковый карданный вал. самоблокирующийся дифференциал на основе системы DTV. cдисплей, камера заднего вида, датчики парковки. электрические стеклоподъемники и зеркала. электрические стеклоподъемники и зеркала. AUX, Bluetooth, USB. электрический привод сидений с памятью, вентиляция. автосвет (ближний/дальний), ксенон, светодиодные фонари. автосвет (ближний/дальний), поворотная оптика, ксенон, светодиодные фонари. двухзонный климат. датчик света, датчик дождя. автоматический круиз. объем багажника max=270 л"

class CarModel {
  CarModel({
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
    this.deposite,
    this.package,
  });

  factory CarModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> json,
  ) {
    final data = json.data();
    return CarModel(
      id: data!['id'] as int,
      images: data['images'] != null ? data['images'] as List<String> : [],
      name: data['name'] as String,
      model: data['model'] as String,
      carLogo: data['car_logo'] as String,
      description: data['description'] as String,
      year: data['year'] as int,
      color: data['color'] as String,
      personCount: data['person_count'] as int,
      engineDescription: data['engine_description'] != null ? data['engine_description'] as List<String> : [],
      output: data['output'] as int,
      fuelDescription: data['fuel_description'] != null ? data['fuel_description'] as List<String> : [],
      transmissionDescription: data['transmission_description'] != null ? data['transmission_description'] as List<String> : [],
      dimensions: data['dimensions'] != null ? data['dimensions'] as List<String> : [],
      rentalPrice: data['rental_price'] as int,
      deposite: data['deposite'] as int,
      package: data['package:'] != null ? data['package'] as List<String> : [],
    );
  }

  factory CarModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CarModel(
      id: int.tryParse(json['id'].toString()),
      images: json['images'] != null ? List<String?>.from(json['images'] as Iterable<dynamic>) : [],
      name: json['name'] as String,
      model: json['model'] as String,
      carLogo: json['car_logo'] as String,
      description: json['description'] as String,
      year: int.tryParse(json['year'].toString().replaceAll(' ', '')),
      color: json['color'] as String,
      personCount: int.tryParse(json['person_count'].toString().contains(' ') ? json['person_count'].toString().replaceAll(' ', '') : json['person_count'].toString()),
      engineDescription: json['engine_description'] != null ? List<String?>.from(json['engine_description'] as Iterable<dynamic>) : [],
      output: int.tryParse(json['output'].toString()),
      fuelDescription: json['fuel_description'] != null ? List<String?>.from(json['fuel_description'] as Iterable<dynamic>) : [],
      transmissionDescription: json['transmission_description'] != null ? List<String?>.from(json['transmission_description'] as Iterable<dynamic>) : [],
      dimensions: json['dimensions'] != null ? List<String?>.from(json['dimensions'] as Iterable<dynamic>) : [],
      rentalPrice: int.tryParse(json['rental_price'].toString().contains(' ') ? json['rental_price'].toString().replaceAll(' ', '') : json['rental_price'].toString()),
      deposite: int.tryParse(json['deposite'].toString().contains(' ') ? json['deposite'].toString().replaceAll(' ', '') : json['deposite'].toString()),
      package: json['package'] != null ? List<String?>.from(json['package'] as Iterable<dynamic>) : [],
    );
  }

  int? id;
  List<String?>? images;
  String? name;
  String? model;
  String? carLogo;
  String? description;
  int? year;
  String? color;
  int? personCount;
  List<String?>? engineDescription;
  int? output;
  List<String?>? fuelDescription;
  List<String?>? transmissionDescription;
  List<String?>? dimensions;
  int? rentalPrice;
  int? deposite;
  List<String?>? package;

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
    map['deposite'] = deposite;
    map['package'] = package;
    return map;
  }
}
