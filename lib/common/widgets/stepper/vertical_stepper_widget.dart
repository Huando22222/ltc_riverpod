// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class VerticalStepperWidget extends StatefulWidget {
  final List<VerticalStepperItemWidget> stepper;
  final double spacing;
  const VerticalStepperWidget({
    super.key,
    required this.stepper,
    this.spacing = 0,
  });

  @override
  State<VerticalStepperWidget> createState() => _VerticalStepperWidgetState();
}

class _VerticalStepperWidgetState extends State<VerticalStepperWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.stepper,
    );
  }
}

class VerticalStepperItemWidget extends StatefulWidget {
  final bool isActive;
  final bool isCheck;
  final bool isFirst;
  final bool isLast;
  final Widget header;
  final Widget? body;

  const VerticalStepperItemWidget({
    super.key,
    this.isActive = false,
    this.isCheck = false,
    this.isFirst = false,
    this.isLast = false,
    required this.header,
    this.body,
  });

  @override
  State<VerticalStepperItemWidget> createState() =>
      _VerticalStepperItemWidgetState();
}

class _VerticalStepperItemWidgetState extends State<VerticalStepperItemWidget> {
  double headerHeight = 0;

  // Màu y tế
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);
  static const Color successGreen = Color(0xFF42A5F5);
  // static const Color successGreen = Color(0xFF43A047);

  @override
  Widget build(BuildContext context) {
    const double indicatorSize = 16;
    const double spacing = 15;
    // const double indicatorSize = 24;
    // const double spacing = 18;

    return CustomPaint(
      painter: _StepperItemCanvas(
        indicatorSize: indicatorSize,
        lineWidth: 3,
        isActive: widget.isActive,
        isCheck: widget.isCheck,
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        headerHeight: headerHeight,
        primaryColor: primaryBlue,
        successColor: successGreen,
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: spacing + indicatorSize,
          bottom: widget.isLast ? 0 : 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MeasureSize(
              onChange: (size) {
                if (headerHeight != size.height) {
                  setState(() => headerHeight = size.height);
                }
              },
              child: widget.header,
            ),
            if (widget.body != null) widget.body!,
          ],
        ),
      ),
    );
  }
}

class _StepperItemCanvas extends CustomPainter {
  final double indicatorSize;
  final double lineWidth;
  final bool isActive;
  final bool isCheck;
  final bool isFirst;
  final bool isLast;
  final double headerHeight;
  final Color primaryColor;
  final Color successColor;

  _StepperItemCanvas({
    required this.indicatorSize,
    required this.lineWidth,
    required this.isActive,
    required this.isCheck,
    required this.isFirst,
    required this.isLast,
    required this.headerHeight,
    required this.primaryColor,
    required this.successColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (headerHeight == 0) return;

    final double indicatorRadius = indicatorSize / 2;
    final Offset indicatorOffset = Offset(indicatorRadius, headerHeight / 2);

    // Draw connecting lines
    final Paint linePaint = Paint()
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Line before indicator
    if (!isFirst) {
      linePaint.color = (isCheck || isActive)
          ? primaryColor
          : Colors.grey[300]!;
      canvas.drawLine(
        Offset(indicatorRadius, 0),
        Offset(indicatorRadius, indicatorOffset.dy - indicatorRadius),
        linePaint,
      );
    }

    // Line after indicator
    if (!isLast) {
      linePaint.color = isCheck ? primaryColor : Colors.grey[300]!;
      canvas.drawLine(
        Offset(indicatorRadius, indicatorOffset.dy + indicatorRadius),
        Offset(indicatorRadius, size.height),
        linePaint,
      );
    }

    // Draw indicator
    if (isCheck) {
      // Completed state - màu xanh lá
      final Paint glowPaint = Paint()
        ..color = successColor.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius + 3, glowPaint);

      final Paint circlePaint = Paint()
        ..color = successColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius, circlePaint);

      // Checkmark
      final Paint checkPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final Path checkPath = Path();
      final double checkSize = indicatorRadius * 0.65;
      checkPath.moveTo(
        indicatorOffset.dx - checkSize * 0.5,
        indicatorOffset.dy,
      );
      checkPath.lineTo(
        indicatorOffset.dx - checkSize * 0.1,
        indicatorOffset.dy + checkSize * 0.45,
      );
      checkPath.lineTo(
        indicatorOffset.dx + checkSize * 0.6,
        indicatorOffset.dy - checkSize * 0.35,
      );

      canvas.drawPath(checkPath, checkPaint);
    } else if (isActive) {
      // Active state - màu xanh dương
      final Paint glowPaint = Paint()
        ..color = primaryColor.withOpacity(0.15)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius + 5, glowPaint);

      final Paint glowPaint2 = Paint()
        ..color = primaryColor.withOpacity(0.25)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius + 2, glowPaint2);

      final Paint borderPaint = Paint()
        ..color = primaryColor
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(indicatorOffset, indicatorRadius, borderPaint);

      final Paint innerPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius - 6, innerPaint);
    } else {
      // Inactive state - MÀU XÁM NHẠT, KHÔNG CÓ MÀU
      final Paint borderPaint = Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5;
      canvas.drawCircle(indicatorOffset, indicatorRadius, borderPaint);

      final Paint innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius - 2, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StepperItemCanvas oldDelegate) {
    return oldDelegate.isActive != isActive ||
        oldDelegate.isCheck != isCheck ||
        oldDelegate.headerHeight != headerHeight;
  }
}

// MeasureSize widget
typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({super.key, required this.onChange, required Widget child})
    : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMeasureSize(onChange);
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  Size? oldSize;
  final OnWidgetSizeChange onChange;

  _RenderMeasureSize(this.onChange);

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size;
    if (oldSize == newSize || newSize == null) return;
    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class HeaderStepperContainer extends StatelessWidget {
  final bool isActive;
  final bool isCheck;
  final VoidCallback? onTap;
  final Widget child;

  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color successGreen = Color(0xFF43A047);

  const HeaderStepperContainer({
    super.key,
    required this.isActive,
    required this.isCheck,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(),
            width: (isActive || isCheck) ? 2 : 1,
          ),
          // boxShadow: isActive
          //     ? [
          //         BoxShadow(
          //           color: primaryBlue.withOpacity(0.15),
          //           blurRadius: 8,
          //           offset: const Offset(0, 2),
          //         ),
          //       ]
          //     : isCheck
          //         ? [
          //             BoxShadow(
          //               color: successGreen.withOpacity(0.1),
          //               blurRadius: 4,
          //               offset: const Offset(0, 1),
          //             ),
          //           ]
          //         : null,
        ),
        child: child,
      ),
    );
  }

  Color _getBackgroundColor() {
    if (isActive) {
      return Colors.white;
    } else if (isCheck) {
      return Colors.white;
      // return successGreen.withOpacity(0.05);
    } else {
      // Inactive - chỉ màu trắng/xám nhạt
      return Colors.white;
    }
  }

  Color _getBorderColor() {
    if (isActive) {
      return primaryBlue;
    } else if (isCheck) {
      return Colors.grey[300]!;
      // return successGreen.withOpacity(0.4);
    } else {
      // Inactive - chỉ màu xám nhạt
      return Colors.grey[300]!;
    }
  }
}
