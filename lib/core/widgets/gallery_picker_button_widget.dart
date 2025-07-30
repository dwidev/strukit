import 'package:flutter/material.dart';

class GalleryPickerButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double size;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;

  const GalleryPickerButton({
    super.key,
    this.onPressed,
    this.size = 50.0,
    this.backgroundColor = const Color(0xFF4F46E5),
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
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withAlpha(30),
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
