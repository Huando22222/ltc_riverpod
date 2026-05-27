import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ltc/core/error/failure.dart';
import 'package:ltc/features/health/data/datasources/bmi_datasource.dart';
import 'package:ltc/features/health/data/repositories/blood_pressure_repository_impl.dart';
import 'package:ltc/features/health/domain/entities/bmi_entity.dart';
import 'package:ltc/features/health/domain/repositories/blood_pressure_repository.dart';
import 'package:ltc/features/health/domain/repositories/bmi_repository.dart';

class BmiRepositoryImpl implements BmiRepository {
  final BmiDatasource _datasource;

  BmiRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<BmiEntity>>> getBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      final response = await _datasource.getBmi(
        userId: userId,
        from: from,
        to: to,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi lấy data bmi'));
    } on DioException catch (e, stackTrace) {
      log('BmiRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('BmiRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(Failure('ERROR UNEXPECTED: bmi ${e.toString()} $stackTrace'));
    }
  }

  @override
  Future<Either<Failure, List<BmiEntity>>> insertBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
    required DateTime recordDate,
    required double weight,
    required double height,
    double? waistCircumference,
    double? hipCircumference,
    double? chestCircumference,
    double? bodyFatPercentage,
    String? note,
  }) async {
    try {
      final response = await _datasource.insertBmi(
        userId: userId,
        from: from,
        to: to,
        recordDate: recordDate,
        height: height,
        weight: weight,
        waistCircumference: waistCircumference,
        hipCircumference: hipCircumference,
        chestCircumference: chestCircumference,
        bodyFatPercentage: bodyFatPercentage,
        note: note,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi insert data bmi'));
    } on DioException catch (e, stackTrace) {
      log('BmiRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('BmiRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(Failure('ERROR UNEXPECTED: bmi ${e.toString()} $stackTrace'));
    }
  }

  @override
  Future<Either<Failure, List<BmiEntity>>> updateBmi({
    required String userId,
    required DateTime from,
    required DateTime to,
    DateTime? recordDate,
    double? weight,
    double? height,
    double? waistCircumference,
    double? hipCircumference,
    double? chestCircumference,
    double? bodyFatPercentage,
    String? note,
    required String metricId,
    bool? isDeleted,
  }) async {
    try {
      final response = await _datasource.updateBmi(
        userId: userId,
        from: from,
        to: to,
        recordDate: recordDate,
        height: height,
        weight: weight,
        waistCircumference: waistCircumference,
        hipCircumference: hipCircumference,
        chestCircumference: chestCircumference,
        bodyFatPercentage: bodyFatPercentage,
        note: note,
        metricId: metricId,
        isDeleted: isDeleted,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi update data bmi'));
    } on DioException catch (e, stackTrace) {
      log('BmiRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('BmiRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(Failure('ERROR UNEXPECTED: bmi ${e.toString()} $stackTrace'));
    }
  }
}

final bmiRepositoryProvider = Provider<BmiRepository>(
  (ref) => BmiRepositoryImpl(ref.read(bmiDatasourceProvider)),
);
