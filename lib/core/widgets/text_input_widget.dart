import 'package:flutter/material.dart';

class TextInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final ValueNotifier<bool>? passwordVisibleNotifier;

  const TextInputWidget({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
    this.passwordVisibleNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ValueListenableBuilder<bool>(
          valueListenable: passwordVisibleNotifier ?? ValueNotifier(false),
          builder: (context, isVisible, _) {
            return TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              obscureText: isPassword ? !isVisible : false,
              validator: validator,
              decoration: InputDecoration(
                hintText: "Masukan ${label.toLowerCase()} anda",
                prefixIcon: Icon(icon, size: 17),
                suffixIcon: isPassword
                    ? IconButton(
                        icon: Icon(
                          isVisible ? Icons.visibility : Icons.visibility_off,
                          size: 17,
                        ),
                        onPressed: () {
                          if (passwordVisibleNotifier != null) {
                            passwordVisibleNotifier!.value =
                                !passwordVisibleNotifier!.value;
                          }
                        },
                      )
                    : null,
              ),
            );
          },
        ),
      ],
    );
  }
}
