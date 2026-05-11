import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeUtil {
  DateTimeUtil._();
  static const List<String> _weekdays = [
    '',
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ];

  static const List<String> _shortWeekdays = [
    '',
    'T2',
    'T3',
    'T4',
    'T5',
    'T6',
    'T7',
    'CN',
  ];

  static String weekdayName(int weekday) => _weekdays[weekday];
  static String shortWeekday(int weekday) => _shortWeekdays[weekday];

  static bool isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// "Thứ Ba, 06/05/2025"
  static String formatDateFull(DateTime d) {
    final date = DateFormat('dd/MM/yyyy').format(d);
    return '${weekdayName(d.weekday)}, $date';
  }

  /// "Thứ Ba, 06/05/2025 · 09:00"
  static String formatBookingSummary(DateTime d, TimeOfDay t) =>
      '${formatDateFull(d)} · ${formatTimeOfDay(t)}';

  static String formatTimeOfDay(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  /// 14 ngày từ hôm nay
  static List<DateTime> upcomingDays({int count = 14}) {
    final today = DateTime.now();
    return List.generate(
      count,
      (i) => DateTime(today.year, today.month, today.day + i),
    );
  }

  static List<TimeOfDay> generate({
    TimeOfDay from = const TimeOfDay(hour: 7, minute: 0),
    TimeOfDay to = const TimeOfDay(hour: 17, minute: 0),
    int stepHours = 1,
  }) {
    final slots = <TimeOfDay>[];
    var current = from;
    while (current.hour <= to.hour) {
      slots.add(current);
      current = TimeOfDay(hour: current.hour + stepHours, minute: 0);
    }
    return slots;
  }

  static bool isMorning(TimeOfDay t) => t.hour < 12;
  static bool isAfternoon(TimeOfDay t) => t.hour >= 12 && t.hour < 18;
}
