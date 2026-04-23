import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.read(authRemoteDatasourceProvider)),
);

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._datasource);
  final AuthRemoteDatasource _datasource;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _datasource.login(
        username: username,
        password: password,
      );
      if (response.data != null) {
        return Right(response.data!);
      }
      return Left(Failure(response.message ?? 'Lỗi đăng nhập'));
    } on DioException catch (e, stackTrace) {
      log('AuthRepositoryImpl: ${e.message} = $stackTrace');
      return Left(Failure(e.message ?? 'ERROR DIO'));
    } catch (e, stackTrace) {
      log('AuthRepositoryImpl: Unexpected error: ${e.toString()} $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: login ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _datasource.logout();
      return const Right(null);
    } catch (e, stackTrace) {
      log('AuthRepositoryImpl: $e = $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: logout ${e.toString()} $stackTrace'),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    try {
      final user = await _datasource.getMe();
      return Right(user);
    } on DioException catch (e, stackTrace) {
      log('AuthRepositoryImpl: $e = $stackTrace');
      final msg = e.response?.data?['message'] ?? 'Lỗi xác thực';
      return Left(Failure(msg));
    } catch (e, stackTrace) {
      log('AuthRepositoryImpl: $e = $stackTrace');
      return Left(
        Failure('ERROR UNEXPECTED: getMe ${e.toString()} $stackTrace'),
      );
    }
  }
}
