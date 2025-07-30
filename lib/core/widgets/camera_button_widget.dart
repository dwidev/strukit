import 'package:flutter/material.dart';
import 'package:strukit/core/themes/app_theme.dart';

class AnimatedCameraButton extends StatefulWidget {
  final Future<void> Function() onPressed;
  final double size;
  final Color innerColor;
  final List<Color> gradientColors;

  const AnimatedCameraButton({
    super.key,
    required this.onPressed,
    this.size = 80.0,
    this.innerColor = Colors.white,
    this.gradientColors = const [AppColors.primary, AppColors.primaryVariant],
  });

  @override
  State<AnimatedCameraButton> createState() => _AnimatedCameraButtonState();
}

class _AnimatedCameraButtonState extends State<AnimatedCameraButton>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _pulseController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  bool _isPressed = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Animation controller untuk rotasi border
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Animation controller untuk scale button
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    // Animation controller untuk pulse effect
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    if (_isLoading) return;
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isLoading) return;
    _handleTapEnd();
  }

  void _handleTapCancel() {
    _handleTapEnd();
  }

  Future<void> _handleTapEnd() async {
    setState(() {
      _isPressed = false;
      _isLoading = true;
    });

    _scaleController.reverse();
    _rotationController.repeat(); // Start loading animation

    // Callback untuk take picture
    await widget.onPressed();
    // Stop loading after callback completes
    setState(() {
      _isLoading = false;
    });
    _rotationController.stop();
    _rotationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _rotationController,
          _scaleController,
          _pulseController,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value * _pulseAnimation.value,
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Loading/Rotating border - only show when loading
                  if (_isLoading)
                    Transform.rotate(
                      angle: _rotationAnimation.value * 3.14159,
                      child: Container(
                        width: widget.size,
                        height: widget.size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Colors.transparent,
                              widget.gradientColors[0],
                              widget.gradientColors[1],
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.4, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                  // Main button circle
                  Container(
                    width: widget.size - 10,
                    height: widget.size - 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.innerColor,
                      border: Border.all(
                        color: _isLoading
                            ? Colors.transparent
                            : widget.gradientColors[0].withAlpha(30),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(50),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _isPressed
                        ? Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  widget.gradientColors[0].withAlpha(20),
                                  widget.gradientColors[1].withAlpha(50),
                                ],
                              ),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
