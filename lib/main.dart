// main.dart
import 'package:flutter/material.dart';
import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/pages/login/login_page.dart';
import 'package:strukit/pages/main_page.dart';
import 'package:strukit/pages/profile/profile_page.dart';
import 'package:strukit/pages/reports/report_page.dart';

void main() {
  runApp(const ReceiptScannerApp());
}

class ReceiptScannerApp extends StatelessWidget {
  const ReceiptScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt Scanner',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
