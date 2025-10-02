import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:strukit/core/themes/app_theme.dart';

// ignore: must_be_immutable
abstract class BaseFlushBar extends Flushbar {
  BaseFlushBar({
    required String title,
    required String message,
    Color? titleColor,
    Color? messageColor,
    super.key,
  }) : super(
         title: title,
         message: message,
         titleColor: titleColor ?? AppColors.lightTextPrimary,
         messageColor: messageColor ?? AppColors.lightTextPrimary,
         flushbarPosition: FlushbarPosition.TOP,
         duration: 2.seconds,
         backgroundColor: Colors.white,
         margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
         borderRadius: BorderRadius.circular(10),
         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
         boxShadows: [
           BoxShadow(
             color: AppColors.darkSurface.withAlpha(40),
             offset: const Offset(0.2, 0.2),
             blurRadius: 20,
           ),
         ],
       );
}
