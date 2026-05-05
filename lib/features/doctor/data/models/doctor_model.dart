import 'package:ltc/features/doctor/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  DoctorModel({
    required super.id,
    required super.name,
    required super.dcomId,
    super.bio,
    super.description,
    super.image,
    super.phone,
    super.scheId,
    super.specId,
    super.title,
  });

  factory DoctorModel.fromJson({required Map<String, dynamic> json}) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      dcomId: json['dcom_id'],
      bio: json['bio'],
      description: json['description'],
      image: json['image'],
      phone: json['phone'],
      scheId: json['sche_id'],
      specId: json['spec_id'],
      title: json['title'],
    );
  }
}
