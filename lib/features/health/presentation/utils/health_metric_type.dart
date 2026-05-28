enum HealthMetricType {
  heartBeat('heart-beat', 'Nhịp tim'),
  bloodOxygen('blood-oxygen', 'SpO₂'),
  bloodPressure('blood-pressure', 'Huyết áp'),
  bmi('bmi', 'BMI'),
  sleep('sleep', 'Giấc ngủ'),
  water('water', 'Uống nước');

  const HealthMetricType(this.routeValue, this.title);

  final String routeValue;
  final String title;

  static HealthMetricType fromRouteValue(String? value) {
    return HealthMetricType.values.firstWhere(
      (type) => type.routeValue == value,
      orElse: () => HealthMetricType.heartBeat,
    );
  }
}
