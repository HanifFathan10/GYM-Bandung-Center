import 'package:flutter/material.dart';
import 'ui/data_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Info GYM Sekitar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFFFF7043),
          surface: const Color(0xFFF5F7FA),
        ),
        useMaterial3: true,
      ),
      home: const DataPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
