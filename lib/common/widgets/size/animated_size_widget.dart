import 'package:flutter/widgets.dart';

class AnimatedSizeWidget extends StatelessWidget {
  final bool isExpanded;
  final Duration duration;
  final Curve curve;
  final Widget child;

  const AnimatedSizeWidget({
    super.key,
    required this.isExpanded,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: AnimatedAlign(
        alignment: Alignment.topCenter,
        duration: duration,
        curve: curve,
        heightFactor: isExpanded ? 1.0 : 0.0,
        child: AnimatedOpacity(
          duration: duration,
          opacity: isExpanded ? 1.0 : 0.0,
          child: child,
        ),
      ),
    );
  }
}
