class UserEntity {
  final String userId;
  String? userSessionId;
  final String username;
  final String fullname;
  final String email;
  final bool isEmailConfirmed;
  final String phoneNumber;
  final bool isPhoneNumberConfirmed;
  final bool isPaused;
  final bool isUpdatePassword;
  final DateTime bod;
  final String sex;
  String? token;
  String? refreshToken;
  final String? userIdGTLTC;

  UserEntity({
    required this.userId,
    required this.userSessionId,
    required this.username,
    required this.fullname,
    required this.email,
    required this.isEmailConfirmed,
    required this.phoneNumber,
    required this.isPhoneNumberConfirmed,
    required this.isPaused,
    required this.isUpdatePassword,
    required this.bod,
    required this.sex,
    this.token,
    this.refreshToken,
    required this.userIdGTLTC,
  });
}

// extension UserMapper on UserEntity {
//   Map<String, dynamic> toJson() {
//     return {'UserId': userId, 'UserName': username};
//   }
// }
