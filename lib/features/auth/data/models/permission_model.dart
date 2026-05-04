import 'package:ltc/features/auth/domain/entities/permission_entity.dart';

class PermissionModel extends PermissionEntity {
  PermissionModel({
    required super.id,
    // required super.userId,
    // required super.groupPermissionId,
    // required super.groupPermissionName,
    // required super.appId,
    // required super.groupType,
  });

  factory PermissionModel.fromJson({required Map<String, dynamic> json}) {
    return PermissionModel(
      id: json['id'],
      // userId: json['user_id'],
      // groupPermissionId: json['group_permission_id'],
      // groupPermissionName: json['group_permission_name'],
      // appId: json['application_id'],
      // groupType: json['group_type'],
    );
  }
  factory PermissionModel.fromEntity(PermissionEntity entity) {
    return PermissionModel(id: entity.id);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'user_id': userId,
    };
  }
}
