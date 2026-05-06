import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/doctor/domain/entities/doctor_entity.dart';

abstract class DoctorRepository {
  Future<Either<Failure, List<DoctorEntity>>> search({
    String? dcomId,
    String? specId,
  });
}
