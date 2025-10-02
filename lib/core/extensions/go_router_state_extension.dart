import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

extension GoRouterStateX on GoRouterState {
  CustomTransitionPage fadeTransition<T>({
    required Widget child,
    Duration? transitionDuration,
  }) =>
      CustomTransitionPage<T>(
        key: pageKey,
        child: child,
        transitionDuration: transitionDuration ?? 1.seconds,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
}
