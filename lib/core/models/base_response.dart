import 'package:ltc/core/models/paginated_response.dart';

class BaseResponse<T> {
  final bool success;
  final String? message;
  T? data;
  final PaginatedResponse? pagination;
  BaseResponse({
    required this.success,
    this.message,
    this.data,
    this.pagination,
  });
  factory BaseResponse.fromJson(
    Map<String, dynamic> json, [
    T Function(dynamic json)? fromJsonT,
  ]) {
    return BaseResponse(
      success: json['succeeded'] ?? json['success'],
      message: json['message'],
      data: json['data'] != null
          ? (fromJsonT != null ? fromJsonT(json['data']) : json['data'] as T)
          : null,
      pagination: json['pagination'] != null
          ? PaginatedResponse.fromJson(json['pagination'])
          : null,
    );
  }
}
