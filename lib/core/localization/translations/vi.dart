import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ltc/common/util/date_time_util.dart';
import 'package:ltc/core/localization/app_strings.dart';

class ViStrings extends AppStrings {
  static const _weekdays = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ];
  static const _short = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
  ViStrings();
  @override
  String get appName => 'LTC';
  @override
  String get appTagline => 'Giải pháp quản lý y tế';
  @override
  String get login => 'Đăng nhập';
  @override
  String get logout => 'Đăng xuất';
  @override
  String get username => 'Tài khoản';
  @override
  String get forgotPassword => 'Quên mật khẩu?';
  @override
  String get loginFailed => 'Đăng nhập thất bại';
  @override
  String get loginInstruction => 'Vui lòng nhập thông tin đăng nhập của bạn.';
  @override
  String get noAccountMessage => 'Chưa có tài khoản?';
  @override
  String get password => 'Mật khẩu';
  @override
  String get register => 'Đăng ký';
  @override
  String get cancel => 'Hủy';
  @override
  String get changeLanguage => 'Đổi ngôn ngữ';
  @override
  String get error => 'Đã xảy ra lỗi';
  @override
  String get loading => 'Đang tải...';
  @override
  String get save => 'Lưu';

  @override
  String get home => 'Trang chủ';
  @override
  String get document => 'Hồ sơ';
  @override
  String get health => 'Sức khỏe';
  @override
  String get profile => 'Tài khoản';

  @override
  String welcome(String name) => 'Xin chào, $name';
  @override
  String required(String field) => '$field không được để trống';

  @override
  String get doctors => 'Bác sĩ';
  @override
  String get features => 'Tính năng';
  @override
  String get medicalTopics => 'Y học gia đình';
  @override
  String get packages => 'Gói dịch vụ';
  @override
  String get testServices => 'Dịch vụ xét nghiệm';
  @override
  String get viewAll => 'Xem Tất Cả';
  @override
  String get explore => 'Tìm hiểu';
  @override
  String get account => 'Tài khoản';
  @override
  String get booking => 'Đặt hẹn';
  @override
  String get changePassword => 'Đổi mật khẩu';
  @override
  String get darkMode => 'Nền tối';
  @override
  String get language => 'Ngôn ngữ';
  @override
  String get languageName => 'Tiếng việt';
  @override
  String get notification => 'Thông báo';
  @override
  String get preferences => 'Tùy chọn';
  @override
  String get security => 'Bảo mật';
  @override
  String get setting => 'Cài đặt';
  @override
  String get contactSupport => 'Liên hệ trợ';
  @override
  String get editProfile => 'Sửa thông tin';
  @override
  String get privacyPolicy => 'Chính sách';
  @override
  String get support => 'Hỗ trợ';
  @override
  String get termOfUse => 'Điều khoản sử dụng';
  @override
  String get guestSubtitle => 'Xem hồ sơ, lịch sử khám và nhiều hơn nữa';
  @override
  String get loginToContinue => 'Đăng nhập để tiếp tục';
  @override
  String get serviceBooking => 'Đặt hẹn dịch vụ';
  @override
  String get specialtyBooking => 'Đặt hẹn chuyên khoa';
  @override
  String get consultation => 'Tư vấn';
  @override
  String get emergency => 'Khẩn cấp';
  @override
  String get labTest => 'Xét nghiệm';
  @override
  String get lookup => 'Tra cứu';
  @override
  String get medication => 'Thuốc';
  @override
  String get specialty => 'Chuyên khoa';
  @override
  String get all => 'Tất cả';
  @override
  String get service => 'Dịch vụ';
  @override
  String get package => 'Gói';
  @override
  String get packageBooking => 'Đặt hẹn gói';
  @override
  String get loginRequiredTitle => 'Đăng nhập để tiếp tục';

  @override
  String loginRequiredSubtitle(String? featureName) {
    if (featureName != null) {
      return 'Bạn cần đăng nhập để sử dụng tính năng "$featureName".';
    }
    return 'Đăng nhập để trải nghiệm đầy đủ các tính năng chăm sóc sức khoẻ của bạn.';
  }

  @override
  String get loginNow => 'Đăng nhập ngay';
  @override
  String get createAccount => 'Tạo tài khoản mới';
  @override
  String get skipContinue => 'Bỏ qua, tiếp tục xem';
  @override
  String get benefitBooking => 'Đặt lịch khám & theo dõi kết quả';
  @override
  String get benefitHealthRecord => 'Lưu trữ hồ sơ sức khoẻ cá nhân';
  @override
  String get benefitMore => 'Và nhiều tính năng khác nữa';
  @override
  String get monday => 'Thứ Hai';
  @override
  String get tuesday => 'Thứ Ba';
  @override
  String get wednesday => 'Thứ Tư';
  @override
  String get thursday => 'Thứ Năm';
  @override
  String get friday => 'Thứ Sáu';
  @override
  String get saturday => 'Thứ Bảy';
  @override
  String get sunday => 'Chủ Nhật';

  @override
  String get monShort => 'T2';
  @override
  String get tueShort => 'T3';
  @override
  String get wedShort => 'T4';
  @override
  String get thuShort => 'T5';
  @override
  String get friShort => 'T6';
  @override
  String get satShort => 'T7';
  @override
  String get sunShort => 'CN';

  @override
  String weekdayName(int w) => _weekdays[w - 1];
  @override
  String shortWeekday(int w) => _short[w - 1];
  @override
  String dayLabel(DateTime d) =>
      DateTimeUtil.isToday(d) ? 'Hôm nay' : shortWeekday(d.weekday);
  @override
  String bookingSummary(DateTime? d, TimeOfDay? t) {
    if (d == null && t == null) return '';
    if (d == null) return DateTimeUtil.formatTimeOfDay(t!);
    if (t == null) {
      return '${weekdayName(d.weekday)}, ${DateFormat('dd/MM/yyyy').format(d)}';
    }
    return '${weekdayName(d.weekday)}, ${DateFormat('dd/MM/yyyy').format(d)} · ${DateTimeUtil.formatTimeOfDay(t)}';
  }

  @override
  String get morning => 'Buổi sáng';
  @override
  String get afternoon => 'Buổi chiều';
  @override
  String get january => 'Tháng 1';
  @override
  String get february => 'Tháng 2';
  @override
  String get march => 'Tháng 3';
  @override
  String get april => 'Tháng 4';
  @override
  String get may => 'Tháng 5';
  @override
  String get june => 'Tháng 6';
  @override
  String get july => 'Tháng 7';
  @override
  String get august => 'Tháng 8';
  @override
  String get september => 'Tháng 9';
  @override
  String get october => 'Tháng 10';
  @override
  String get november => 'Tháng 11';
  @override
  String get december => 'Tháng 12';

  @override
  String get janShort => 'Th1';
  @override
  String get febShort => 'Th2';
  @override
  String get marShort => 'Th3';
  @override
  String get aprShort => 'Th4';
  @override
  String get mayShort => 'Th5';
  @override
  String get junShort => 'Th6';
  @override
  String get julShort => 'Th7';
  @override
  String get augShort => 'Th8';
  @override
  String get sepShort => 'Th9';
  @override
  String get octShort => 'Th10';
  @override
  String get novShort => 'Th11';
  @override
  String get decShort => 'Th12';
  @override
  String monthName(int m) => [
    january,
    february,
    march,
    april,
    may,
    june,
    july,
    august,
    september,
    october,
    november,
    december,
  ][m];

  @override
  String shortMonth(int m) => [
    janShort,
    febShort,
    marShort,
    aprShort,
    mayShort,
    junShort,
    julShort,
    augShort,
    sepShort,
    octShort,
    novShort,
    decShort,
  ][m];
  @override
  String get pickDate => 'Chọn ngày';
  @override
  String get pickTime => 'Chọn giờ';
  @override
  String get pickDateAndTime => 'Chọn ngày và khung giờ khám';
  @override
  String get today => 'Hôm nay';
  @override
  String get next => 'Tiếp theo';

  // MARK: BOOKING STEPS
  @override
  String get patientInfo => 'Thông tin bệnh nhân';
  @override
  String get fillPatientInfo => 'Điền thông tin người đặt khám';
  @override
  String get confirmBooking => 'Xác nhận đặt lịch';
  @override
  String get checkAndConfirm => 'Kiểm tra và xác nhận thông tin';
  @override
  String get bookingSuccess => 'Đã đặt lịch thành công';
  @override
  String get estimatedFee => 'Phí tạm tính';
  @override
  String get editService => 'Chỉnh sửa dịch vụ';
  @override
  String get free => 'Miễn phí';
  @override
  String get pickService => 'Chọn dịch vụ khám';

  @override
  String selectedServiceCount(int count) =>
      count == 0 ? pickService : '$count dịch vụ đã chọn';
}
