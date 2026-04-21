import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.userId,
    required super.username,
    required super.fullname,
    required super.email,
    required super.isEmailConfirmed,
    required super.phoneNumber,
    required super.isPhoneNumberConfirmed,
    required super.isPaused,
    required super.isUpdatePassword,
    required super.bod,
    required super.sex,
    required super.token,
    required super.refreshToken,
    required super.userIdGTLTC,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['UserId'],
      username: json['UserName'],
      fullname: json['FullName'],
      email: json['Email'],
      isEmailConfirmed: json['EmailConfirmed'],
      phoneNumber: json['PhoneNumber'],
      isPhoneNumberConfirmed: json['PhoneNumberConfirmed'],
      isPaused: json['Pause'],
      isUpdatePassword: json['isUpdatePassword'],
      bod: DateTime.parse(json['PERBOD']),
      sex: json['PERSEX'],
      token: null, //json['jwt_token'],
      refreshToken: null, //json['refreshToken'],
      userIdGTLTC: json['IduserGtltc'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'UserName': username,
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
