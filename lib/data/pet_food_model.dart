class PetFoodModel {
  int? id;
  int? dogId;
  String? name;
  int? max;
  int? daily;
  DateTime? startDate;

  PetFoodModel.fromMap(dynamic obj) {
    id = obj['id'];
    dogId = obj['dogId'];
    name = obj['name'];
    max = obj['max'];
    daily = obj['daily'];
    startDate = obj['startDate'] != null ? DateTime.parse(obj['startDate']) : null;
  }

  PetFoodModel({this.dogId, this.max, this.name, this.daily, this.startDate});

  Map<String, dynamic> toMap() {
    return {
      'dogId': dogId,
      'name': name,
      'max': max,
      'daily': daily,
      'startDate': startDate?.toIso8601String()
    };
  }
}