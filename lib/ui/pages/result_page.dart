import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/search_state.dart';
import '../widgets/result_card.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchState>(
      builder: (context, state, _) {
        final response = state.currentResponse;
        return LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 820 ? 28.0 : 16.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 20),
              child: _sectionCard(
                title: '搜索结果',
                child: response == null
                    ? const Text('还没有结果，请先在首页拍照或选图搜题。')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('OCR 文本', style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Text(response.ocrText.isEmpty ? '无识别文本' : response.ocrText),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '匹配结果 (${response.results.length})',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          if (response.results.isEmpty)
                            const Text('未匹配到题目')
                          else
                            for (var index = 0; index < response.results.length; index++)
                              ResultCard(
                                item: response.results[index],
                                rank: index + 1,
                              ),
                        ],
                      ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
