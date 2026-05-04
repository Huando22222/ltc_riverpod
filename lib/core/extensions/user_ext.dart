import 'package:ltc/core/constants/role_constants.dart';
import 'package:ltc/features/auth/domain/entities/user_entity.dart';

extension UserRoleExt on UserEntity {
  bool get isAdmin => role.map((e) => e.id).contains(RoleConstants.admin);
  bool get isPartner => role.map((e) => e.id).contains(RoleConstants.partner);
  bool get isPatient => role.map((e) => e.id).contains(RoleConstants.patient);
}
