import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/booking/domain/usecases/booking_service_usecase.dart';

abstract class BookingRepository {
  Future<Either<Failure, String>> booking({required BookingParams params});
}
