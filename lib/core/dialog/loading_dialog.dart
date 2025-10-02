import 'package:flutter/material.dart';

import '../themes/app_theme.dart';

void showLoading(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, a, s) {
      return Material(
        type: MaterialType.transparency,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkSurfaceVariant,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const CircularProgressIndicator.adaptive(),
          ),
        ),
      );
    },
  );
}
