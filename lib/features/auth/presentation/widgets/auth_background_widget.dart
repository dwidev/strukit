import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/themes/app_theme.dart';

class AuthBackgroundWidget extends StatelessWidget {
  const AuthBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.getGradients(context),
          stops: [0.0, 0.3],
        ),
      ),
      child: Stack(
        children: [
          // Floating Circles with flutter_animate
          Positioned(
            top: 100,
            left: 50,
            child:
                Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.toOpacity(0.1),
                            Colors.white.toOpacity(0.05),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: 20,
                      duration: 3000.ms,
                      curve: Curves.easeInOut,
                    )
                    .moveX(
                      begin: 0,
                      end: 15,
                      duration: 2500.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          Positioned(
            top: 200,
            right: 30,
            child:
                Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.toOpacity(0.15),
                            Colors.white.toOpacity(0.03),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: -25,
                      duration: 2800.ms,
                      curve: Curves.easeInOut,
                    )
                    .moveX(
                      begin: 0,
                      end: 10,
                      duration: 3200.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          Positioned(
            bottom: 150,
            left: 30,
            child:
                Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.toOpacity(0.2),
                            Colors.white.toOpacity(0.05),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: 30,
                      duration: 2200.ms,
                      curve: Curves.easeInOut,
                    )
                    .moveX(
                      begin: 0,
                      end: -5,
                      duration: 2700.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Additional floating elements
          Positioned(
            top: 300,
            left: 200,
            child:
                Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.toOpacity(0.08),
                            Colors.white.toOpacity(0.02),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: -15,
                      duration: 3500.ms,
                      curve: Curves.easeInOut,
                    )
                    .moveX(
                      begin: 0,
                      end: 20,
                      duration: 2000.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Mesh Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.5),
                radius: 1.5,
                colors: [Colors.white.toOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
