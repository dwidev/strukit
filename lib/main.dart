// main.dart
import 'package:flutter/material.dart';
import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/pages/home_page.dart';
import 'package:strukit/pages/login_page.dart';

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
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
