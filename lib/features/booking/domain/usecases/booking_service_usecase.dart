import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/booking/domain/repositories/booking_repository.dart';
import '../../../../core/error/failure.dart';

class BookingParams {
  final String id;
  final bool sex;
  final String address;
  final DateTime dob;
  final String name;
  final String phone;
  final String refName;
  final String refPhone;
  final String dcomId;
  final String? symptom;
  final String? note;
  final String? request;
  final String userId;
  final String userRefId;
  final DateTime bookingDateTime;
  final double discountAmount;
  final double discountPercent;
  final int status;
  final double price;
  final String createdBy;
  final List<BookingServiceParams> details;
  BookingParams({
    this.id = "00000000-0000-0000-0000-000000000000",
    required this.sex,
    required this.address,
    required this.dob,
    required this.name,
    required this.phone,
    required this.refName,
    required this.refPhone,
    required this.dcomId,
    this.symptom,
    this.note,
    this.request,
    required this.userId,
    required this.userRefId,
    required this.bookingDateTime,
    required this.discountAmount,
    required this.discountPercent,
    required this.status,
    required this.price,
    required this.createdBy,
    required this.details,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_sex': sex,
      'booking_address': address,
      'booking_dob': dob.toIso8601String(),
      'booking_name': name,
      'booking_phone': phone,
      'ref_name': refName,
      'ref_phone': refPhone,
      'dcom_id': dcomId,
      'symptom': symptom,
      'note': note,
      'request': request,
      'user_id': userId,
      'user_ref_id': userRefId,
      'date_time': bookingDateTime.toIso8601String(),
      'discount_amount': discountAmount,
      'discount_percent': discountPercent,
      'status': status,
      'price': price,
      'created_by': createdBy,
      'details': details.map((e) => e.toJson()).toList(),
    };
  }
}

class BookingServiceParams {
  final String? id;
  final String? aptId;
  final String? docId;
  final String? pkgId;
  final String serId;
  final double serCurrentTotal;
  final String? specId;

  BookingServiceParams({
    this.id,
    this.aptId,
    this.docId,
    this.pkgId,
    required this.serId,
    required this.serCurrentTotal,
    this.specId,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'apt_id': aptId,
      'doc_id': docId,
      'pkg_id': pkgId,
      'ser_id': serId,
      'ser_current_total': serCurrentTotal,
      'spec_id': specId,
    };
  }
}

class BookingServiceUsecase {
  const BookingServiceUsecase(this._repository);
  final BookingRepository _repository;

  Future<Either<Failure, String>> call({required BookingParams params}) {
    return _repository.booking(params: params);
  }
}

final bookingUsecaseProvider = Provider<BookingServiceUsecase>(
  (ref) => BookingServiceUsecase(ref.read(bookingRepositoryProvider)),
);
