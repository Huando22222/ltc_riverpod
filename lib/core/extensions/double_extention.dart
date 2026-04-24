import 'package:intl/intl.dart';

extension DoubleExt on double {
  String get formatCurrency {
    return NumberFormat('#,##0.#').format(this);
  }
}
