import 'package:flutter/material.dart';

import '../../models/search_result_item.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.item,
    required this.rank,
  });

  final SearchResultItem item;
  final int rank;

  @override
  Widget build(BuildContext context) {
    final score = item.score == null ? 'N/A' : item.score!.toStringAsFixed(4);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F766E),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Top $rank',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  '匹配分: $score',
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              '题目',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(item.questionText),
            const SizedBox(height: 10),
            const Text(
              '答案',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(item.answerText),
          ],
        ),
      ),
    );
  }
}
