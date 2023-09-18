class DogModel {
  int? id;
  String? image;
  String? name;
  String? city;
  String? sex;
  DateTime? date;

  DogModel.fromMap(dynamic obj) {
    id = obj['id'];
    name = obj['name'];
    sex = obj['sex'] == 'male' ? 'Pies' : 'Suczka';
    city = obj['city'];
    date = obj['birthDate'] != null ? DateTime.parse(obj['birthDate']) : null;
    image = obj['imagePath'];
  }

  DogModel({this.image, this.name, this.date, this.city, this.sex});

  Map<String, dynamic> toMap() {
    return {
      'imagePath': image,
      'name': name,
      'sex': sex,
      'city': city,
      'birthDate': date?.toIso8601String()
    };
  }
}