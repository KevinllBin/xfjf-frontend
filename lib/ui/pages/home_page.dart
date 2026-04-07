import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/search_state.dart';
import 'history_page.dart';
import 'result_page.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _switchTo(int index) {
    if (_currentIndex == index) {
      return;
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchState>(
      builder: (context, state, _) {
        final body = state.isInitialized ? _buildContent(state) : const _LoadingState();

        return Scaffold(body: body);
      },
    );
  }

  Widget _buildContent(SearchState state) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFDF8EE),
            Color(0xFFEFF8F6),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  SearchPage(
                    onSearchSuccess: () => _switchTo(1),
                    onOpenHistory: () => _switchTo(2),
                  ),
                  const ResultPage(),
                  HistoryPage(
                    onSelectHistory: () => _switchTo(1),
                  ),
                ],
              ),
            ),
            NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _switchTo,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: '首页',
                ),
                NavigationDestination(
                  icon: Icon(Icons.description_outlined),
                  selectedIcon: Icon(Icons.description),
                  label: '结果',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_outlined),
                  selectedIcon: Icon(Icons.history),
                  label: '历史',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          Text('正在初始化...'),
        ],
      ),
    );
  }
}
