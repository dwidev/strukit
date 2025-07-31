import 'package:flutter/material.dart';
import 'package:strukit/core/themes/app_theme.dart';

class GalleryPickerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color iconColor;
  final IconData icon;

  const GalleryPickerButton({
    super.key,
    this.onPressed,
    this.size = 50.0,
    this.iconColor = Colors.white,
    this.icon = Icons.photo_library,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: AppTheme.getGradients(context)),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkBackground.withAlpha(30),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.5),
      ),
    );
  }
}
