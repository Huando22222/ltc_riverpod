import '../../domain/entities/booking_data_entity.dart';
import 'booking_data_detail_model.dart';

class BookingDataModel extends BookingDataEntity {
  const BookingDataModel({
    required super.id,
    required super.ptnName,
    super.ptnPhone,
    super.ptnId,
    required super.status,
    super.regId,
    required super.createdAt,
    required super.services,
  });

  factory BookingDataModel.fromJson(Map<String, dynamic> json) {
    return BookingDataModel(
      id: json['id'],
      ptnName: json['ptn_name'],
      ptnPhone: json['ptn_phone'],
      ptnId: json['ptn_id'],
      status: json['status'] ?? '',
      regId: json['reg_id'],
      createdAt: DateTime.parse(json['created_at']),
      services:
          (json['services'] as List?)
              ?.map((e) => BookingDataDetailModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  factory BookingDataModel.fromEntity(BookingDataEntity entity) {
    return BookingDataModel(
      id: entity.id,
      ptnName: entity.ptnName,
      ptnPhone: entity.ptnPhone,
      ptnId: entity.ptnId,
      status: entity.status,
      regId: entity.regId,
      createdAt: entity.createdAt,
      services: entity.services.map(BookingDataDetailModel.fromEntity).toList(),
    );
  }
}
