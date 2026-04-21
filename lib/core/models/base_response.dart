import 'package:ltc/core/models/paginated_response.dart';

class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final PaginatedResponse? pagination;
  const BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.pagination,
  });
  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json) fromJsonT,
  ) {
    return BaseResponse(
      success: json['succeeded'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      pagination: json['pagination'] != null
          ? PaginatedResponse.fromJson(json['pagination'])
          : null,
    );
  }
}
