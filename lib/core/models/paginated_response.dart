// ignore_for_file: public_member_api_docs, sort_constructors_first

class PaginatedResponse {
  final int page;
  final int pageSize;
  final int totalPage;
  final int total;
  final bool hasNext;
  final bool hasPrev;

  PaginatedResponse({
    required this.page,
    required this.pageSize,
    required this.totalPage,
    required this.total,
    required this.hasNext,
    required this.hasPrev,
  });

  factory PaginatedResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedResponse(
      page: json['page'],
      pageSize: json['page_size'],
      totalPage: json['total_page'],
      total: json['total'],
      hasNext: json['has_next'],
      hasPrev: json['has_prev'],
    );
  }
}
