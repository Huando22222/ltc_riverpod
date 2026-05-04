import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/booking/domain/entities/service_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure, ServiceEntity>> search({String? search});
}
