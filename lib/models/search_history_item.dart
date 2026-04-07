import 'search_result_item.dart';

class SearchHistoryItem {
  const SearchHistoryItem({
    required this.id,
    required this.createdAt,
    required this.ocrText,
    required this.results,
  });

  final String id;
  final DateTime createdAt;
  final String ocrText;
  final List<SearchResultItem> results;

  factory SearchHistoryItem.fromJson(Map<String, dynamic> json) {
    final rawResults = json['results'];
    final resultItems = <SearchResultItem>[];
    if (rawResults is List) {
      for (final item in rawResults) {
        if (item is Map<String, dynamic>) {
          resultItems.add(SearchResultItem.fromJson(item));
        }
      }
    }

    return SearchHistoryItem(
      id: (json['id'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['created_at'] ?? '').toString()) ?? DateTime.now(),
      ocrText: (json['ocr_text'] ?? '').toString(),
      results: resultItems,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'ocr_text': ocrText,
      'results': results.map((item) => item.toJson()).toList(),
    };
  }
}
