class BookingDataDetailEntity {
  final String? regSerId;
  final DateTime? dateSign;

  final String? packageId;
  final String? packageName;

  final String serId;
  final String serName;
  final double serTotal;

  final int groupType;
  final String serGroupName;
  final String serGroupId;

  final bool isLink;
  final bool isCompleted;

  const BookingDataDetailEntity({
    this.regSerId,
    this.dateSign,
    this.packageId,
    this.packageName,
    required this.serId,
    required this.serName,
    required this.serTotal,
    required this.groupType,
    required this.serGroupName,
    required this.serGroupId,
    required this.isLink,
    required this.isCompleted,
  });
}
