import 'package:ltc/features/specialty/domain/entities/specialty_entity.dart';

class SpecialtyModel extends SpecialtyEntity {
  SpecialtyModel({
    required super.id,
    required super.name,
    super.image,
    super.description,
  });

  factory SpecialtyModel.fromJson({required Map<String, dynamic> json}) {
    return SpecialtyModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      image: json['image'],
    );
  }
}
