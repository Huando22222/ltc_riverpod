class ApiException implements Exception {
  const ApiException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ApiException($statusCode): $message';

  factory ApiException.fromDioError(dynamic error) {
    if (error?.response?.data != null) {
      final data = error.response!.data;
      return ApiException(
        message: data['message'] ?? 'Đã xảy ra lỗi',
        statusCode: error.response?.statusCode,
      );
    }
    return const ApiException(message: 'Không thể kết nối server');
  }
}
