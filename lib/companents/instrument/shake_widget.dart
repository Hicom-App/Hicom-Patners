import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AnimationControllerState<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin {
  AnimationControllerState(this.animationDuration);

  final Duration animationDuration;

  late final animationController =
  AnimationController(vsync: this, duration: animationDuration);

  late final CurvedAnimation animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.elasticInOut, // You can change the curve here
  );

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    required this.shakeOffset,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 400),
    this.shakeDirection = Axis.horizontal, // New parameter for shake direction
  }) : super(key: key);

  final Widget child;
  final double shakeOffset;
  final int shakeCount;
  final Duration shakeDuration;
  final Axis shakeDirection; // Direction of the shake

  @override
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation, // Use the curved animation for smoother effect
      child: widget.child,
      builder: (context, child) {
        final sineValue =
        sin(widget.shakeCount * pi * 2 * animation.value);
        //double offset = sin(_shakeAnimation.value * pi * 2);

        // Shake logic based on direction
        final offset = widget.shakeDirection == Axis.horizontal
            ? Offset(sineValue * widget.shakeOffset, 0)
            : (widget.shakeDirection == Axis.vertical
            ? Offset(0, sineValue * widget.shakeOffset)
            : Offset(sineValue * widget.shakeOffset,
            sineValue * widget.shakeOffset)); // Both directions

        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
    );
  }
}

// Usage Example: Custom TextView Widget
Widget customTextView({
  required double cornerRadius,
  required Color backgroundColor,
  required double height,
  required int limitTextLength,
  required GlobalKey<ShakeWidgetState> shakeKey,
  required TextEditingController controller,
  required Color alertColor,
  required Color normalColor,
  required String fontFamily,
}) {
  int textCount = 0;

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(cornerRadius),
      color: backgroundColor,
    ),
    height: height,
    child: Column(
      children: [
        Flexible(
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(limitTextLength),
            ],
            onChanged: (value) {
              textCount = controller.text.length;
              if (textCount == limitTextLength) {
                shakeKey.currentState?.shake(); // Trigger shake
              }
            },
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
            ),
            textInputAction: TextInputAction.newline,
            keyboardType: TextInputType.multiline,
            minLines: null,
            maxLines: null,
            expands: true,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: ShakeWidget(
                key: shakeKey,
                shakeOffset: 2,
                shakeCount: 10,
                shakeDuration: const Duration(milliseconds: 500),
                shakeDirection: Axis.horizontal, // Can be Axis.vertical or both
                child: Text(
                  '$textCount/$limitTextLength',
                  style: TextStyle(
                    color: (textCount > (limitTextLength * 0.9))
                        ? alertColor
                        : normalColor,
                    fontSize: 12,
                    fontFamily: fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
