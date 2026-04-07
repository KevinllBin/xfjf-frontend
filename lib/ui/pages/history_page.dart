import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/search_state.dart';
import '../widgets/history_tile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
    required this.onSelectHistory,
  });

  final VoidCallback onSelectHistory;

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchState>(
      builder: (context, state, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 820 ? 28.0 : 16.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(horizontalPadding, 14, horizontalPadding, 20),
              child: _sectionCard(
                title: '历史记录（最多20条）',
                trailing: state.recentSearches.isEmpty
                    ? null
                    : TextButton.icon(
                        onPressed: state.clearHistory,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('清空'),
                      ),
                child: state.recentSearches.isEmpty
                    ? const Text('暂无历史记录')
                    : Column(
                        children: state.recentSearches
                            .map(
                              (item) => HistoryTile(
                                item: item,
                                onTap: () {
                                  context.read<SearchState>().selectHistoryItem(item);
                                  onSelectHistory();
                                },
                              ),
                            )
                            .toList(growable: false),
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
    Widget? trailing,
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
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
