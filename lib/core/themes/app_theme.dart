// theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF4F46E5); // Indigo-600
  static const primaryVariant = Color(0xFF06B6D4); // Cyan-600
  static const secondary = Color(0xFF2196F3); // Green-500

  // Background Colors
  static const background = Color(0xFFF9FAFB); // Gray-50
  static const surface = Colors.white;
  static const surfaceVariant = Color(0xFFF3F4F6); // Gray-100

  // Text Colors
  static const textPrimary = Color(0xFF111827); // Gray-900
  static const textSecondary = Color(0xFF6B7280); // Gray-500
  static const textTertiary = Color(0xFF9CA3AF); // Gray-400

  // Status Colors
  static const success = Color(0xFF4CAF50); // Green-500
  static const warning = Color(0xFFF59E0B); // Amber-500
  static const error = Color(0xFFEF4444); // Red-500

  // Gradient Colors
  static const gradientStart = primary; // Indigo-600
  static const gradientMiddle = Color(0xFF7C3AED); // Purple-600
  static const gradientEnd = primaryVariant; // Cyan-600
}

extension ColorExt on Color {
  Color toOpacity(double value) {
    return withAlpha((value * 255).toInt());
  }
}

class AppTheme {
  static var gradientsSecondary;

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineSmall: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
        bodySmall: TextStyle(
          color: AppColors.textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  static List<Color> get gradients {
    return [AppColors.gradientStart, AppColors.gradientEnd];
  }
}
