// ignore_for_file: must_be_immutable

import 'package:strukit/core/themes/app_theme.dart';

import 'base_flushbar.dart';

class WarningFlushBar extends BaseFlushBar {
  WarningFlushBar({super.key, required super.title, required super.message})
    : super(titleColor: AppColors.primary, messageColor: AppColors.primary);
}
