// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:strukit/core/themes/app_theme.dart';

class CustomLinearProgressIndicator extends StatefulWidget {
  final bool isComplete;
  final Duration? completionDuration;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double? height;
  final double borderRadius;
  final VoidCallback? onComplete;
  final double? value; // Default value parameter
  final List<Color>? gradientColors;

  const CustomLinearProgressIndicator({
    super.key,
    this.isComplete = false,
    this.completionDuration,
    this.backgroundColor,
    this.gradient,
    this.height,
    this.borderRadius = 4.0,
    this.onComplete,
    this.value,
    this.gradientColors,
  });

  @override
  State<CustomLinearProgressIndicator> createState() =>
      _CustomLinearProgressIndicatorState();
}

class _CustomLinearProgressIndicatorState
    extends State<CustomLinearProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _completionController;
  late AnimationController _indeterminateController;
  late Animation<double> _completionAnimation;
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Set initial value jika ada default value
    if (widget.value != null) {
      _currentValue = widget.value!.clamp(0.0, 1.0);
    }

    // Controller untuk animasi completion (0 -> 1)
    _completionController = AnimationController(
      duration: widget.completionDuration ?? const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Controller untuk animasi indeterminate
    _indeterminateController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _completionAnimation = Tween<double>(begin: 0.0, end: widget.value ?? 1.0)
        .animate(
          CurvedAnimation(
            parent: _completionController,
            curve: Curves.easeInOut,
          ),
        );

    // Listener untuk update value completion
    _completionAnimation.addListener(() {
      setState(() {
        _currentValue = _completionAnimation.value;
      });
    });

    // Listener untuk callback ketika selesai
    _completionController.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.onComplete != null) {
        widget.onComplete!();
      }
    });

    // Start animation berdasarkan kondisi
    if (widget.value != null || widget.isComplete) {
      _completionController.reset();
      _completionController.forward();
    }
  }

  @override
  void didUpdateWidget(CustomLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update duration jika berubah
    if (widget.completionDuration != oldWidget.completionDuration) {
      _completionController.duration =
          widget.completionDuration ?? const Duration(milliseconds: 1500);
    }

    // Handle perubahan isComplete atau value
    if (widget.isComplete != oldWidget.isComplete ||
        widget.value != oldWidget.value) {
      if (widget.value != null) {
        // Jika ada value, langsung set tanpa animasi
        _completionController.stop();
        setState(() {
          _currentValue = widget.value!.clamp(0.0, 1.0);
        });
      } else if (widget.isComplete) {
        // Mulai completion dari 0
        _completionController.reset();
        _completionController.forward();
      } else {
        // Reset ke 0 untuk mode LinearProgressIndicator
        _completionController.reset();
        setState(() {
          _currentValue = 0.0;
        });
      }
    }
  }

  @override
  void dispose() {
    _completionController.dispose();
    _indeterminateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Jika tidak complete dan tidak ada value, gunakan LinearProgressIndicator default
    if (!widget.isComplete && widget.value == null) {
      return SizedBox(
        height: widget.height ?? 4.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: LinearProgressIndicator(
            backgroundColor: widget.backgroundColor ?? Colors.grey[300],
            valueColor: widget.gradient != null
                ? null // Gradient tidak bisa digunakan di LinearProgressIndicator
                : AlwaysStoppedAnimation<Color>(AppColors.secondary),
            minHeight: widget.height ?? 4.0,
          ),
        ),
      );
    }

    // Untuk mode complete atau ada value, gunakan custom
    return Container(
      height: widget.height ?? 4.0,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.grey[300],
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: _buildProgress(),
      ),
    );
  }

  Widget _buildProgress() {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: _currentValue,
        child: Container(
          decoration: BoxDecoration(
            gradient:
                widget.gradient ??
                LinearGradient(
                  colors: widget.gradientColors ?? AppTheme.gradientsOrange,
                ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      ),
    );
  }
}
