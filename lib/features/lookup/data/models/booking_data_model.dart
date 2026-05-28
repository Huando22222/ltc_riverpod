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
    required super.appointmentDateTime,
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
      appointmentDateTime: DateTime.parse(json['appointment_date_time']),
      createdAt: DateTime.parse(json['created_at']),
      services:
          (json['services'] as List?)
              ?.map((e) => BookingDataDetailModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
