import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/booking/data/models/booking_param_mode.dart';
import 'package:ltc/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:ltc/features/booking/domain/repositories/booking_repository.dart';
import '../../../../core/error/failure.dart';

class BookingServiceUsecase {
  const BookingServiceUsecase(this._repository);
  final BookingRepository _repository;

  Future<Either<Failure, String>> call({required BookingParamModel params}) {
    return _repository.booking(params: params);
  }
}

final bookingUsecaseProvider = Provider<BookingServiceUsecase>(
  (ref) => BookingServiceUsecase(ref.read(bookingRepositoryProvider)),
);
