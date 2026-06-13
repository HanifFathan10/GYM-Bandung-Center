import 'package:flutter/material.dart';

class AppTheme {
  // 1. Sentralisasi Kode Warna (Color Palette)
  static const Color bgDark = Color(0xFF0F0F11);
  static const Color cardDark = Color(0xFF1E1E22);
  static const Color primaryBlue = Color(0xFF1565C0);

  // 2. Sentralisasi Warna Teks
  static const Color textWhite = Colors.white;
  static final Color textSub = Colors.grey.shade500;

  // 3. Sentralisasi Konfigurasi Tema Utama Aplikasi
  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: bgDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: const Color(0xFFFF7043),
        surface: bgDark,
        brightness: Brightness.dark, // Mengunci aplikasi ke Dark Mode
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textWhite),
        titleTextStyle: TextStyle(
          color: textWhite,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      useMaterial3: true,
    );
  }
}
