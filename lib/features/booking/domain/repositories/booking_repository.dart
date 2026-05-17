import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/booking/data/models/booking_param_mode.dart';

abstract class BookingRepository {
  Future<Either<Failure, String>> booking({required BookingParamModel params});
}
