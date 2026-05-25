import 'package:ltc/features/lookup/domain/entities/booking_data_detail_entity.dart';
class GroupItemEntity {
  final String id;
  final String name;
  final bool isPackage;
  final List<BookingDataDetailEntity> services;

  const GroupItemEntity({
    required this.id,
    required this.name,
    required this.isPackage,
    required this.services,
  });
}
