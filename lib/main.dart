import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'state/search_state.dart';
import 'ui/pages/home_page.dart';

void main() {
  runApp(const QuestionSearchApp());
}

class QuestionSearchApp extends StatelessWidget {
  const QuestionSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final seedScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF155E75),
      brightness: Brightness.light,
    );

    return ChangeNotifierProvider(
      create: (_) => SearchState()..initialize(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: '拍照搜题',
        theme: ThemeData(
          colorScheme: seedScheme,
          scaffoldBackgroundColor: const Color(0xFFF7F4EE),
          textTheme: GoogleFonts.notoSansScTextTheme(),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
