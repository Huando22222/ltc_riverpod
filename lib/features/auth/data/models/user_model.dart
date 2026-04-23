import 'dart:convert';

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
    super.token,
    super.refreshToken,
    super.userIdGTLTC,
  });

  factory UserModel.fromJson({required Map<String, dynamic> json}) {
    return UserModel(
      userId: json['UserId'],
      username: json['UserName'],
      userSessionId: json['UserSessionId'],
      fullname: json['FullName'],
      email: json['Email'],
      isEmailConfirmed: json['EmailConfirmed'],
      phoneNumber: json['PhoneNumber'],
      isPhoneNumberConfirmed: json['PhoneNumberConfirmed'],
      isPaused: json['Pause'],
      isUpdatePassword: json['isUpdatePassword'],
      bod: DateTime.parse(json['PERBOD']),
      sex: json['PERSEX'],
      token: json['jwt_token'],
      refreshToken: json['refreshToken'],
      userIdGTLTC: json['IduserGtltc'],
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
      'jwt_token': token,
      'refreshToken': refreshToken,
      'IduserGtltc': userIdGTLTC,
    };
  }
}
