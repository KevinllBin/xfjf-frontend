class SearchResultItem {
  const SearchResultItem({
    required this.questionText,
    required this.answerText,
    this.id,
    this.score,
  });

  final int? id;
  final double? score;
  final String questionText;
  final String answerText;

  factory SearchResultItem.fromJson(Map<String, dynamic> json) {
    return SearchResultItem(
      id: _readInt(json['id']),
      score: _readDouble(json['score']),
      questionText: (json['question_text'] ?? '').toString(),
      answerText: (json['answer_text'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'question_text': questionText,
      'answer_text': answerText,
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

  static double? _readDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}
