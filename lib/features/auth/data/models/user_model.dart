import 'dart:convert';

import 'package:ltc/core/extensions/string_ext.dart';
import 'package:ltc/features/auth/data/models/permission_model.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.username,
    required super.userSessionId,
    required super.fullname,
    required super.email,
    required super.isEmailConfirmed,
    required super.phoneNumber,
    required super.isPhoneNumberConfirmed,
    required super.isPaused,
    required super.isUpdatePassword,
    required super.bod,
    required super.sex,
    super.address,
    super.token,
    super.refreshToken,
    super.userIdGTLTC,
    required super.role,
  });

  factory UserModel.fromJson({required Map<String, dynamic> json}) {
    return UserModel(
      userId: json['UserId'],
      username: json['UserName'] ?? 'Guest',
      userSessionId: json['UserSessionId'],
      fullname: (json['FullName'] as String?)?.isNullOrEmpty ?? true
          ? 'Tôi'
          : json['FullName'] as String,
      email: json['Email'],
      isEmailConfirmed: json['EmailConfirmed'],
      phoneNumber: json['PhoneNumber'],
      isPhoneNumberConfirmed: json['PhoneNumberConfirmed'],
      isPaused: json['Pause'],
      isUpdatePassword: json['isUpdatePassword'],
      bod: DateTime.parse(json['PERBOD']),
      sex: json['PERSEX'] ?? 'Nam',
      address: json['PERADD'],
      token: json['jwt_token'],
      refreshToken: json['refreshToken'],
      userIdGTLTC: json['IduserGtltc'],
      role: (json['list_Permission'] as List)
          .map((e) => PermissionModel.fromJson(json: e))
          .toList(),
    );
  }
  factory UserModel.fromRawJson(String str) {
    final jsonMap = jsonDecode(str) as Map<String, dynamic>;
    return UserModel.fromJson(json: jsonMap);
  }
  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'UserName': username,
      'UserSessionId': userSessionId,
      'FullName': fullname,
      'Email': email,
      'EmailConfirmed': isEmailConfirmed,
      'PhoneNumber': phoneNumber,
      'PhoneNumberConfirmed': isPhoneNumberConfirmed,
      'Pause': isPaused,
      'isUpdatePassword': isUpdatePassword,
      'PERBOD': bod.toIso8601String(),
      'PERSEX': sex,
      'PERADD': address,
      'jwt_token': token,
      'refreshToken': refreshToken,
      'IduserGtltc': userIdGTLTC,
      'list_Permission': role
          .map((e) => PermissionModel.fromEntity(e).toJson())
          .toList(),
    };
  }
}
