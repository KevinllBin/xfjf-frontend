import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/search_history_item.dart';

class HistoryTile extends StatelessWidget {
  const HistoryTile({
    super.key,
    required this.item,
    required this.onTap,
  });

  final SearchHistoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final timeText = DateFormat('MM-dd HH:mm').format(item.createdAt);
    final ocrPreview = item.ocrText.replaceAll('\n', ' ').trim();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, size: 18, color: Color(0xFF0F766E)),
                const SizedBox(width: 6),
                Text(
                  timeText,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              ocrPreview.isEmpty ? '无识别文本' : ocrPreview,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
