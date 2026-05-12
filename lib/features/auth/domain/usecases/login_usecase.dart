import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';

class LoginUsecase {
  const LoginUsecase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, UserEntity>> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username: username, password: password);
  }
}

final loginUsecaseProvider = Provider<LoginUsecase>(
  (ref) => LoginUsecase(ref.read(authRepositoryProvider)),
);
