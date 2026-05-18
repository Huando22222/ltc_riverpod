class CurrencyUtil {
  static String formatPrice(double price) {
    if (price <= 0) return '-';
    return '${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')}đ';
  }
}
