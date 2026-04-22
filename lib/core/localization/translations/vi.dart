import 'package:ltc/core/localization/app_strings.dart';

class ViStrings extends AppStrings {
  ViStrings();
  @override
  String get appName => 'LTC';
  @override
  String get appTagline => 'Giải pháp quản lý y tế';

  @override
  String get authLogin => 'Đăng nhập';
  @override
  String get authLogout => 'Đăng xuất';
  @override
  String get authUsername => 'Tài khoản';

  @override
  String get authForgotPassword => 'Quên mật khẩu?';
  @override
  String get authLoginFailed => 'Đăng nhập thất bại';
  @override
  String get authLoginInstruction =>
      'Vui lòng nhập thông tin đăng nhập của bạn.';
  @override
  String get authNoAccountMessage => 'Chưa có tài khoản?';
  @override
  String get authPassword => 'Mật khẩu';
  @override
  String get authRegister => 'Đăng ký';
  @override
  String get commonCancel => 'Hủy';
  @override
  String get commonChangeLanguage => 'Đổi ngôn ngữ';
  @override
  String get commonError => 'Đã xảy ra lỗi';
  @override
  String get commonLoading => 'Đang tải...';
  @override
  String get commonSave => 'Lưu';

  @override
  String welcome(String name) => 'Xin chào, $name';
  @override
  String required(String field) => '$field không được để trống';
}
