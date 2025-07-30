import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/core/widgets/gradient_button_widget.dart';

class ScanButton extends StatelessWidget {
  final VoidCallback onTap;

  const ScanButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withAlpha(30),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Scan Struk',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Foto struk untuk tracking otomatis',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            GradientButtonWidget(
              onPressed: () {},
              loading: false,
              options: GradientButtonWidgetOptions(
                title: "Mulai Scan",
                icon: CupertinoIcons.qrcode,
                trailingIcon: Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
