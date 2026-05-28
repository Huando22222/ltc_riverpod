import 'package:ltc/features/lookup/domain/entities/booking_data_detail_entity.dart';

class BookingDataEntity {
  final String id;
  final String ptnName;
  final String? ptnPhone;
  final String? ptnId;
  final String status;
  final String? regId;
  final DateTime appointmentDateTime;
  final DateTime createdAt;
  final List<BookingDataDetailEntity> services;

  const BookingDataEntity({
    required this.id,
    required this.ptnName,
    this.ptnPhone,
    this.ptnId,
    required this.status,
    this.regId,
    required this.appointmentDateTime,
    required this.createdAt,
    required this.services,
  });
}
