import 'search_result_item.dart';

class SearchResponse {
  const SearchResponse({
    required this.ocrText,
    required this.count,
    required this.results,
  });

  final String ocrText;
  final int count;
  final List<SearchResultItem> results;

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'];
    final results = <SearchResultItem>[];
    if (rawResults is List) {
      for (final item in rawResults) {
        if (item is Map<String, dynamic>) {
          results.add(SearchResultItem.fromJson(item));
        }
      }
    }

    final responseCount = _readInt(json['count']) ?? results.length;
    return SearchResponse(
      ocrText: (json['ocr_text'] ?? '').toString(),
      count: responseCount,
      results: results,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ocr_text': ocrText,
      'count': count,
      'results': results.map((item) => item.toJson()).toList(),
    };
  }

  static int? _readInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    return int.tryParse(value.toString());
  }
}
