import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/lookup/data/models/booking_data_model.dart';
import 'package:ltc/features/lookup/data/repositories/booking_data_repository_impl.dart';
import 'package:ltc/features/lookup/domain/repositories/booking_data_repository.dart';

class GetBookingDataUsecase {
  final BookingDataRepository _repository;
  GetBookingDataUsecase(this._repository);

  Future<Either<Failure, List<BookingDataModel>>> call({
    required String userRefId,
    required DateTime from,
    required DateTime to,
    int page = 1,
    int pageSize = 10,
  }) async {
    return await _repository.getBookingDataHistory(
      userRefId: userRefId,
      from: from,
      to: to,
      page: page,
      pageSize: pageSize,
    );
  }
}

final getBookingDataUsecaseProvider = Provider<GetBookingDataUsecase>(
  (ref) => GetBookingDataUsecase(ref.read(bookingDataRepositoryProvider)),
);
