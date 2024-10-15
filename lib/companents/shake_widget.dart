import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/get_controller.dart';

@immutable
class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    super.key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  });

  /// Convert 0-1 to -1-0-1 for left and right shaking
  double shake(double animation) {
    double t = curve.transform(animation);
    return (t < 0.5 ? (t * 2 - 1) : (1 - (t - 0.5) * 2)); // Create a left and right shake effect
  }

  @override
  Widget build(BuildContext context) {
    final GetController controller = Get.find();

    return Obx(() {
      return controller.shouldShake.value
          ? TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: duration,
        onEnd: () {
          controller.shouldShake.value = false; // Reset shake state
        },
        builder: (context, animation, child) {
          // Calculate the offset based on the animation value
          double offset = deltaX * shake(animation);
          return Transform.translate(
            offset: Offset(offset, 0), // Horizontal shaking
            child: child,
          );
        },
        child: child,
      )
          : child; // Return child without shaking
    });
  }
}
