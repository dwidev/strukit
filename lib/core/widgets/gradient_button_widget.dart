import 'package:flutter/material.dart';

import 'package:strukit/core/themes/app_theme.dart';

class GradientButtonWidgetOptions {
  final String title;
  final IconData icon;
  final IconData? trailingIcon;

  GradientButtonWidgetOptions({
    required this.title,
    required this.icon,
    this.trailingIcon,
  });
}

class GradientButtonWidget extends StatelessWidget {
  const GradientButtonWidget({
    super.key,
    required this.onPressed,
    required this.options,
    this.loading = false,
  });

  final bool loading;
  final VoidCallback onPressed;
  final GradientButtonWidgetOptions options;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,

      decoration: BoxDecoration(
        gradient: LinearGradient(colors: AppTheme.getGradients(context)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkBackground.toOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(options.icon, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    options.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (options.trailingIcon != null) ...[
                    const SizedBox(width: 8),
                    Icon(options.trailingIcon, size: 20),
                  ],
                ],
              ),
      ),
    );
  }
}
