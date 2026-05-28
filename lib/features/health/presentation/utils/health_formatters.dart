import 'package:intl/intl.dart';

class HealthFormatters {
  HealthFormatters._();

  static String number(num value) {
    final pattern = value % 1 == 0 ? '#,##0' : '#,##0.#';
    return NumberFormat(pattern, 'vi_VN').format(value);
  }

  static String sleepHours(int minutes) {
    return number(minutes / 60);
  }

  static String date(DateTime value) {
    return DateFormat('dd/MM/yyyy').format(value);
  }

  static String shortDate(DateTime value) {
    return DateFormat('dd/MM').format(value);
  }

  static String time(DateTime value) {
    return DateFormat('HH:mm').format(value);
  }

  static String range(DateTime from, DateTime to) {
    return '${date(from)} - ${date(to)}';
  }
}
