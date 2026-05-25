import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/lookup/data/datasources/booking_data_datasource.dart';
import 'package:ltc/features/lookup/data/models/booking_data_model.dart';
import 'package:ltc/features/lookup/domain/repositories/booking_data_repository.dart';

class BookingDataRepositoryImpl extends BookingDataRepository {
  final BookingDataDatasource _datasource;

  BookingDataRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<BookingDataModel>>> getBookingDataHistory({
    required String userRefId,
    required DateTime from,
    required DateTime to,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _datasource.getBookingDataHistory(
        userRefId: userRefId,
        from: from,
        to: to,
        page: page,
        pageSize: pageSize,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi lấy lịch sử đặt phòng'));
    } on DioException catch (e, stackTrace) {
      log('BookingDataRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log(
        'BookingDataRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace',
      );
      return Left(
        Failure(
          'ERROR UNEXPECTED: getBookingDataHistory ${e.toString()} $stackTrace',
        ),
      );
    }
  }
}

final bookingDataRepositoryProvider = Provider<BookingDataRepository>(
  (ref) => BookingDataRepositoryImpl(ref.read(bookingDataDatasourceProvider)),
);
