import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';

class RegisterUsecase {
  const RegisterUsecase(this._repository);
  final AuthRepository _repository;

  Future<Either<Failure, bool>> call({
    required String username,
    required String password,
    required List<String> roleId,
    required String phone,
    String? email,
  }) {
    return _repository.register(
      username: username,
      password: password,
      phone: phone,
      email: email,
      roleId: roleId,
    );
  }
}

final registerUsecaseProvider = Provider<RegisterUsecase>(
  (ref) => RegisterUsecase(ref.read(authRepositoryProvider)),
);
