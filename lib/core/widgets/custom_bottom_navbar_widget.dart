// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:strukit/core/themes/app_theme.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback? onScanTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onScanTap,
  });

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  double _getIndicatorPosition() {
    double itemWidth = (MediaQuery.of(context).size.width - 80) / 5;
    double basePosition = 0;

    if (widget.currentIndex == 0) return basePosition + itemWidth * 0.5;
    if (widget.currentIndex == 1) return basePosition + itemWidth * 1.5;
    if (widget.currentIndex == 2) {
      return basePosition + itemWidth * 3.73; // History
    }
    if (widget.currentIndex == 3) {
      return basePosition + itemWidth * 4.719; // Profile
    }

    return basePosition + itemWidth * 0.5; // Default to home
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.toOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated indicator dot
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: _getIndicatorPosition() - 10,
            child:
                Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: AppColors.primaryVariant.toOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    )
                    .animate()
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1.2, 1.2),
                      duration: 1000.ms,
                      curve: Curves.easeInOut,
                    )
                    .then()
                    .scale(
                      begin: const Offset(1.2, 1.2),
                      end: const Offset(0.8, 0.8),
                      duration: 1000.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Navigation items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                isActive: widget.currentIndex == 0,
                onTap: () => widget.onTap(0),
              ),

              _NavItem(
                icon: Icons.bar_chart_rounded,
                isActive: widget.currentIndex == 1,
                onTap: () => widget.onTap(1),
              ),

              // Scanner Button
              _ScannerButton(onScanTap: widget.onScanTap),

              _NavItem(
                icon: Icons.receipt_long_rounded,
                isActive: widget.currentIndex == 2,
                onTap: () => widget.onTap(2),
              ),

              _NavItem(
                icon: Icons.person_rounded,
                isActive: widget.currentIndex == 3,
                onTap: () => widget.onTap(3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScannerButton extends StatefulWidget {
  const _ScannerButton({required this.onScanTap});

  final VoidCallback? onScanTap;

  @override
  State<_ScannerButton> createState() => _ScannerButtonState();
}

class _ScannerButtonState extends State<_ScannerButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onScanTap,
      child:
          Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.toOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:
                    const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                          size: 24,
                        )
                        .animate(target: _isPressed ? 1 : null)
                        .shimmer(color: AppColors.secondary, duration: 500.ms),
              )
              .animate(target: _isPressed ? 1 : 0)
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(0.95, 0.95),
                duration: 100.ms,
                curve: Curves.easeOut,
              ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child:
          SizedBox(
                width: 45,
                height: 45,
                child: Icon(
                  widget.icon,
                  color: widget.isActive
                      ? AppColors.secondary
                      : AppColors.textSecondary,
                  size: 22,
                ),
              )
              .animate(target: _isPressed ? 1 : 0)
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(0.95, 0.95),
                duration: 100.ms,
                curve: Curves.easeOut,
              )
              .animate(target: widget.isActive ? 1 : 0)
              .scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.08, 1.08),
                duration: 200.ms,
                curve: Curves.easeOut,
              ),
    );
  }
}
