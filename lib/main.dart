import 'package:flutter/material.dart';
import 'package:street_performance_helper/pages/title_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: TitleScreen(),
    );
  }
}
