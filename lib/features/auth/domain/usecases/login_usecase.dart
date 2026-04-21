import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LoginParams {
  const LoginParams({required this.username, required this.password});
  final String username;
  final String password;
}

class LoginUsecase {
  const LoginUsecase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.login(
      username: params.username,
      password: params.password,
    );
  }
}

final loginUsecaseProvider = Provider<LoginUsecase>(
  (ref) => LoginUsecase(ref.read(authRepositoryProvider)),
);
