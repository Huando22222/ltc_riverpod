import 'package:ltc/features/booking/domain/entities/patient_booking_entity.dart';

class GenderUtil {
  static Gender toGender(String v) {
    final l = v.toLowerCase();
    if (l == 'male' || l == 'nam') {
      return Gender.male;
    } else if (l == 'female' || l == 'nữ' || l == 'nu') {
      return Gender.female;
    }
    return Gender.male;
  }
}
