import 'package:intl/intl.dart';

extension DateTimeExt on DateTime {
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  String formatTimeDDMMYYYY() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  DateTime onlyDate() => DateTime(year, month, day);

  /// So sánh theo ngày (bỏ qua giờ, phút, giây)
  /// Trả về:
  /// - `-1` nếu this < other
  /// - `0` nếu cùng ngày
  /// - `1` nếu this > other
  int compareDate(DateTime other) {
    final d1 = onlyDate();
    final d2 = other.onlyDate();
    if (d1.isAtSameMomentAs(d2)) return 0;
    return d1.isBefore(d2) ? -1 : 1;
  }

  bool isSameDate(DateTime other) => compareDate(other) == 0;

  /// Sau hoặc bằng ngày
  bool isAfterOrSameDate(DateTime other) => compareDate(other) >= 0;

  /// Trước hoặc bằng ngày
  bool isBeforeOrSameDate(DateTime other) => compareDate(other) <= 0;
}
