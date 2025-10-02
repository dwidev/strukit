import 'package:dev_utils/extensions/context_extensions.dart';
import 'package:dev_utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:strukit/core/themes/app_theme.dart';

enum SocialButtonType {
  google,
  apple;

  IconData get icon => switch (this) {
    apple => FontAwesomeIcons.apple,
    google => FontAwesomeIcons.google,
  };
}

class SocialButtonWidget extends StatelessWidget {
  const SocialButtonWidget({
    super.key,
    required this.onTap,
    required this.type,
  });

  final VoidCallback onTap;
  final SocialButtonType type;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final bgColor = brightness != Brightness.dark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    final color = brightness == Brightness.dark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.toOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(type.icon, color: color, size: 19),
            const SizedBox(width: 8),
            Text(
              type.name.capitalize(),
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
