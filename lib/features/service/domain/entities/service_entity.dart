class ServiceEntity {
  final String dcomId;
  final String serId;
  final String serName;
  final String? specId;
  final String serGroupId;
  final String serGroupName;
  final double serPrice;
  final double serTotal;
  final String serType;
  final bool isActive;
  final bool isLogicDel;

  ServiceEntity({
    required this.dcomId,
    required this.serId,
    required this.serName,
    this.specId,
    required this.serGroupId,
    required this.serGroupName,
    required this.serPrice,
    required this.serTotal,
    required this.serType,
    required this.isActive,
    required this.isLogicDel,
  });
}
