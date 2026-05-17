import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:ltc/features/booking/data/models/booking_param_mode.dart';
import 'package:ltc/features/booking/domain/repositories/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepositoryImpl(ref.read(bookingRemoteDatasourceProvider)),
);

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDatasource _datasource;
  const BookingRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, String>> booking({
    required BookingParamModel params,
  }) async {
    try {
      final response = await _datasource.booking(params: params);
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi get booking'));
    } catch (e, stackTrace) {
      log("BookingRepositoryImpl ERROR: $e = $stackTrace");
      return Left(Failure('ERROR UNEXPECTED: ${e.toString()} $stackTrace'));
    }
  }
}
