// theme/app_colors.dart
part of 'app_theme.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF4F46E5); // Indigo-600
  static const primaryVariant = Color(0xFF06B6D4); // Cyan-600
  static const secondary = Color(0xFF2196F3); // Blue-500

  // Light Theme Colors
  static const lightBackground = Color(0xFFF9FAFB); // Gray-50
  static const lightSurface = Colors.white;
  static const lightSurfaceVariant = Color(0xFFF3F4F6); // Gray-100

  static const lightTextPrimary = Color(0xFF111827); // Gray-900
  static const lightTextSecondary = Color(0xFF6B7280); // Gray-500
  static const lightTextTertiary = Color(0xFF9CA3AF); // Gray-400

  // Dark Theme Colors
  static const darkBackground = Color(0xFF0F0F0F); // Very dark gray
  static const darkSurface = Color(0xFF1F1F1F); // Dark gray
  static const darkSurfaceVariant = Color(0xFF2A2A2A); // Lighter dark gray

  static const darkTextPrimary = Color(
    0xFFB3B7C2,
  ); // Gray-400 - primary yang sangat muted
  static const darkTextSecondary = Color(
    0xFF8B8FA3,
  ); // Gray-500 - secondary yang gelap
  static const darkTextTertiary = Color(
    0xFF6B7280,
  ); // Gray-500 - tertiary yang hampir blur

  // Status Colors (same for both themes)
  static const success = Color(0xFF4CAF50); // Green-500
  static const warning = Color(0xFFF59E0B); // Amber-500
  static const error = Color(0xfFEF4444); // Red-500

  // Gradient Colors for Light Theme
  static const lightGradientStart = primary; // Indigo-600
  static const lightGradientEnd = primaryVariant; // Cyan-600

  // Gradient Colors for Dark Theme (darker, more subtle)
  static const darkGradientStart = Color(0xFF1E1B4B); // Indigo-900
  static const darkGradientEnd = Color(0xFF164E63); // Cyan-900

  // Orange Gradients for Light Theme
  static const lightOrangeGradientStart = warning;
  static const lightOrangeGradientEnd = error;

  // Orange Gradients for Dark Theme (darker orange tones)
  static const darkOrangeGradientStart = Color(0xFF92400E); // Amber-800
  static const darkOrangeGradientEnd = Color(0xFF991B1B); // Red-800
}

extension ColorExt on Color {
  Color toOpacity(double value) {
    return withAlpha((value * 255).toInt());
  }
}
