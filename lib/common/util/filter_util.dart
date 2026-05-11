import 'dart:math' as math;

class FilterUtil {
  static double calculateSimilarity(String query, String text) {
    if (query.isEmpty || text.isEmpty) return 0.0;

    query = query.toLowerCase().trim();
    text = text.toLowerCase().trim();

    // Khớp chính xác hoàn toàn
    if (text == query) {
      return 1.0;
    }

    // Chứa chuỗi tìm kiếm hoàn chỉnh
    if (text.contains(query)) {
      double positionScore = 1.0 - (text.indexOf(query) / text.length);
      return 0.8 + (0.2 * positionScore);
    }

    // Bắt đầu với chuỗi tìm kiếm
    if (text.startsWith(query)) {
      return 0.75;
    }

    // Tính điểm dựa trên số ký tự chung (chỉ cho gợi ý)
    int commonChars = 0;
    for (int i = 0; i < query.length; i++) {
      if (text.contains(query[i])) {
        commonChars++;
      }
    }

    double commonScore = commonChars / query.length;
    return commonScore > 0.5 ? commonScore * 0.4 : 0.0; // Giảm điểm gợi ý
  }

  //!===========================
  /// Filter data with search functionality
  ///
  /// [data] - List of items to search through
  /// [query] - Search query string
  /// [searchFields] - Function that returns list of searchable strings for each item
  /// [exactMatchThreshold] - Minimum score for exact matches (default: 0.7)
  /// [suggestionThreshold] - Minimum score for suggestions (default: 0.0)
  static List<T> filterData<T>(
    List<T> data,
    String query, {
    required List<String> Function(T item) searchFields,
    double exactMatchThreshold = 1.0,
    double suggestionThreshold = 0.5,
    bool searchByContain = false, // ✅ Thêm flag mới
  }) {
    if (query.isEmpty) {
      return List.from(data);
    }

    String searchQuery = query.toLowerCase().trim();
    List<(T item, double score)> scoredItems = [];

    for (var item in data) {
      List<String> fields = searchFields(item);
      double maxScore = 0.0;

      for (String field in fields) {
        String fieldLower = field.toLowerCase().trim();

        if (searchByContain) {
          // log("Checking: '$fieldLower' contains '$searchQuery'");
          if (fieldLower.contains(searchQuery)) {
            // log("✅ Found match!");
            maxScore = 1.0;
            break; // Không cần kiểm tra các field còn lại
          }
        } else {
          double score = calculateSimilarity(searchQuery, fieldLower);
          maxScore = math.max(maxScore, score);
        }
      }

      if (maxScore > suggestionThreshold) {
        scoredItems.add((item, maxScore));
      }
    }

    // Sort by score (descending)
    scoredItems.sort((a, b) => b.$2.compareTo(a.$2));

    // Tách exact match và gợi ý
    List<T> exactMatches = [];
    List<T> suggestions = [];

    for (var (item, score) in scoredItems) {
      if (score >= exactMatchThreshold) {
        exactMatches.add(item);
      } else {
        suggestions.add(item);
      }
    }

    // log(
    //   "Exact matches: ${exactMatches.length}, Suggestions: ${suggestions.length}",
    // );
    // Nếu có exact match thì trả exact match trước
    return exactMatches.isNotEmpty ? exactMatches : suggestions;
  }
}
