import 'package:ltc/features/booking/domain/entities/patient_booking_entity.dart';

extension GenderExt on Gender {
  bool get isMale => this == Gender.male;

  String genderLabel() {
    return switch (this) {
      Gender.male => 'Nam',
      Gender.female => 'Nữ',
      // Gender.other => 'Khác',
    };
  }
}
