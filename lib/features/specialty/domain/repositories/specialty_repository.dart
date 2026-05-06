import 'package:dartz/dartz.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/specialty/domain/entities/specialty_entity.dart';

abstract class SpecialtyRepository {
  Future<Either<Failure, List<SpecialtyEntity>>> getClinicSpecialty({
    String? dcomId,
  });
}
