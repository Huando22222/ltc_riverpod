import 'package:ltc/features/lookup/domain/entities/booking_data_detail_entity.dart';

class BookingDataDetailModel extends BookingDataDetailEntity {
  const BookingDataDetailModel({
    super.regSerId,
    super.dateSign,
    super.packageId,
    super.packageName,
    required super.serId,
    required super.serName,
    required super.serTotal,
    required super.groupType,
    required super.serGroupName,
    required super.serGroupId,
    required super.isLink,
    required super.isCompleted,
  });

  factory BookingDataDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDataDetailModel(
      regSerId: json['reg_ser_id'],
      dateSign: json['date_sign'] != null
          ? DateTime.tryParse(json['date_sign'])
          : null,

      packageId: json['pkg_id'],
      packageName: json['pkg_name'],

      serId: json['ser_id'] ?? '-',
      serName: json['ser_name'] ?? '-',

      serTotal: (json['ser_total'] as num?)?.toDouble() ?? 0,

      groupType: json['grp_type'] ?? 0,

      serGroupName: json['ser_grp_name'] ?? '-',

      serGroupId: json['ser_grp_id'] ?? '-',

      isLink: json['is_link'] ?? false,

      isCompleted: json['is_complete'] ?? false,
    );
  }

  factory BookingDataDetailModel.fromEntity(BookingDataDetailEntity entity) {
    return BookingDataDetailModel(
      regSerId: entity.regSerId,
      dateSign: entity.dateSign,
      packageId: entity.packageId,
      packageName: entity.packageName,
      serId: entity.serId,
      serName: entity.serName,
      serTotal: entity.serTotal,
      groupType: entity.groupType,
      serGroupName: entity.serGroupName,
      serGroupId: entity.serGroupId,
      isLink: entity.isLink,
      isCompleted: entity.isCompleted,
    );
  }
}
