extension StringExt on String? {
  bool get isNullOrEmpty {
    return this == null || this!.trim().isEmpty;
  }

  bool get isNotNullOrEmpty {
    return !isNullOrEmpty;
  }
}
