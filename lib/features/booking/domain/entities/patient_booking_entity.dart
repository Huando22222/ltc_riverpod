// patient_booking_entity.dart
import 'package:ltc/features/auth/domain/entities/user_entity.dart';

enum Gender {
  male,
  female,
  // , other
}

class PatientBookingEntity {
  final String fullname;
  final Gender gender;
  final DateTime dob;
  final String phoneNumber;
  final String? address;
  final String? symptom;
  final String? request;
  final String? note;

  const PatientBookingEntity({
    required this.fullname,
    required this.gender,
    required this.dob,
    required this.phoneNumber,
    this.address,
    this.symptom,
    this.request,
    this.note,
  });

  /// Tạo từ UserEntity khi chọn "Bản thân"
  factory PatientBookingEntity.fromUser(UserEntity user) {
    return PatientBookingEntity(
      fullname: user.fullname,
      gender: _parseGender(user.sex),
      dob: user.bod,
      phoneNumber: user.phoneNumber,
      address: user.address,
    );
  }

  static Gender _parseGender(String sex) => switch (sex.toLowerCase()) {
    'male' || 'nam' || 'm' => Gender.male,
    'female' || 'nữ' || 'f' => Gender.female,
    _ => Gender.male,
    // _ => Gender.other,
  };

  static bool genderBool(Gender gender) => gender == Gender.male;
}
