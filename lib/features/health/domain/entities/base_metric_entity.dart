class BaseMetricEntity {
  final String metricId;
  final String userId;
  final DateTime recordDate;

  BaseMetricEntity({
    required this.metricId,
    required this.userId,
    required this.recordDate,
  });
}
