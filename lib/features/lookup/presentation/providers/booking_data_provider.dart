import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/features/auth/domain/entities/user_entity.dart';
import 'package:ltc/features/auth/presentation/providers/auth_provider.dart';
import 'package:ltc/features/lookup/data/models/booking_data_model.dart';
import 'package:ltc/features/lookup/domain/usecases/get_booking_data_usecase.dart';

class BookingDataNotifier extends AsyncNotifier<List<BookingDataModel>> {
  @override
  Future<List<BookingDataModel>> build() async {
    final UserEntity? auth = ref.watch(currentUserProvider);

    if (auth == null) {
      return [];
    }

    return fetchBookingData(
      userRefId: auth.userId,
      from: DateTime.now().subtract(const Duration(days: 3000)),
      to: DateTime.now().add(const Duration(days: 600)),
    );
  }

  GetBookingDataUsecase get _getBookingData =>
      ref.read(getBookingDataUsecaseProvider);

  Future<List<BookingDataModel>> fetchBookingData({
    required String userRefId,
    required DateTime from,
    required DateTime to,
    int page = 1,
    int pageSize = 10,
  }) async {
    final result = await _getBookingData(
      userRefId: userRefId,
      from: from,
      to: to,
      page: page,
      pageSize: pageSize,
    );

    return result.fold((failure) => [], (bookingDataList) => bookingDataList);
  }
}

final bookingDataProvider =
    AsyncNotifierProvider<BookingDataNotifier, List<BookingDataModel>>(
      BookingDataNotifier.new,
    );
