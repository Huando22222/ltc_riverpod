import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/lookup/data/models/booking_data_model.dart';

abstract class BookingDataRepository {
  Future<Either<Failure, List<BookingDataModel>>> getBookingDataHistory({
    required String userRefId,
    required DateTime from,
    required DateTime to,
    int page = 1,
    int pageSize = 10,
  });
}
