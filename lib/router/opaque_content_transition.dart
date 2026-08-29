import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OpaqueContentTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final motion = CurvedAnimation(
      parent: animation,
      curve: curve ?? Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.65, end: 1).animate(motion),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(motion),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(motion),
            child: child,
          ),
        ),
      ),
    );
  }
}
