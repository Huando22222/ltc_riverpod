class Validators {
  Validators._();
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên đăng nhập';
    }
    if (value.trim().length < 4) {
      return 'Tên đăng nhập phải có ít nhất 4 ký tự';
    }
    if (value.trim().length > 30) {
      return 'Tên đăng nhập không được vượt quá 30 ký tự';
    }
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    if (!usernameRegex.hasMatch(value.trim())) {
      return 'Tên đăng nhập chỉ gồm chữ, số và dấu gạch dưới (_)';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    // Chấp nhận +84 hoặc 0 đầu, 9–10 chữ số
    final phoneRegex = RegExp(r'^(\+84|0)[0-9]{9,10}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Số điện thoại không hợp lệ (VD: 0912345678)';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập mật khẩu';
    }
    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }
    if (value.length > 64) {
      return 'Mật khẩu không được vượt quá 64 ký tự';
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String password) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Vui lòng xác nhận mật khẩu';
      }
      if (value != password) {
        return 'Mật khẩu xác nhận không khớp';
      }
      return null;
    };
  }

  /// Trả về null nếu rỗng (email là tùy chọn)
  static String? emailOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Email không hợp lệ';
    }
    return null;
  }
}
