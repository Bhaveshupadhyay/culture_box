import 'package:flutter/material.dart';
import 'app/theme/app_theme.dart';
import 'features/movies/presentation/pages/home_page.dart';

void main() {
  runApp(const CultureBoxApp());
}

class CultureBoxApp extends StatelessWidget {
  const CultureBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CultureBox TV Network',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
