import 'package:flutter/material.dart';
import 'package:ltc/features/health/presentation/utils/health_metric_type.dart';

class HealthMetricInfo {
  const HealthMetricInfo({
    required this.type,
    required this.title,
    required this.value,
    required this.unit,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.displayDate,
    this.isAttention = false,
  });

  final HealthMetricType type;
  final String title;
  final String value;
  final String unit;
  final String subtitle;
  final IconData icon;
  final Color color;
  final DateTime? displayDate;
  final bool isAttention;

  bool get hasValue => value != '--';
}

class HealthDetailInfo {
  const HealthDetailInfo({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class HealthSignalStatus {
  const HealthSignalStatus({required this.label, required this.isGood});

  final String label;
  final bool isGood;
}
