// ─────────────────────────────────────────────
// VERTICAL STEPPER WIDGET
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';

class VerticalStepperWidget extends StatelessWidget {
  final List<VerticalStepperItemWidget> stepper;

  const VerticalStepperWidget({super.key, required this.stepper});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: stepper,
    );
  }
}

// ─────────────────────────────────────────────
// VERTICAL STEPPER ITEM WIDGET
// ─────────────────────────────────────────────

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

  @override
  Widget build(BuildContext context) {
    const double indicatorSize = 18;
    const double spacing = 16;

    return CustomPaint(
      painter: _StepperItemCanvas(
        indicatorSize: indicatorSize,
        lineWidth: 2,
        isActive: widget.isActive,
        isCheck: widget.isCheck,
        isFirst: widget.isFirst,
        isLast: widget.isLast,
        headerHeight: headerHeight,
        primaryColor: Theme.of(context).colorScheme.primary,
        successColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Theme.of(context).colorScheme.outlineVariant,
      ),
      child: Container(
        padding: EdgeInsets.only(
          left: spacing + indicatorSize,
          bottom: widget.isLast ? 0 : 16,
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

// ─────────────────────────────────────────────
// STEPPER CANVAS PAINTER
// ─────────────────────────────────────────────

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
  final Color inactiveColor;

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
    required this.inactiveColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (headerHeight == 0) return;

    final double indicatorRadius = indicatorSize / 2;
    final Offset indicatorOffset = Offset(indicatorRadius, headerHeight / 2);

    final Paint linePaint = Paint()
      ..strokeWidth = lineWidth
      ..style = PaintingStyle.stroke;

    // Line before indicator
    if (!isFirst) {
      linePaint.color = (isCheck || isActive) ? primaryColor : inactiveColor;
      canvas.drawLine(
        Offset(indicatorRadius, 0),
        Offset(indicatorRadius, indicatorOffset.dy - indicatorRadius),
        linePaint,
      );
    }

    // Line after indicator
    if (!isLast) {
      linePaint.color = isCheck ? primaryColor : inactiveColor;
      canvas.drawLine(
        Offset(indicatorRadius, indicatorOffset.dy + indicatorRadius),
        Offset(indicatorRadius, size.height),
        linePaint,
      );
    }

    // Draw indicator
    if (isCheck) {
      final Paint fillPaint = Paint()
        ..color = successColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius, fillPaint);

      final Paint checkPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      final Path checkPath = Path();
      final double s = indicatorRadius * 0.55;
      checkPath.moveTo(indicatorOffset.dx - s * 0.5, indicatorOffset.dy);
      checkPath.lineTo(
        indicatorOffset.dx - s * 0.05,
        indicatorOffset.dy + s * 0.45,
      );
      checkPath.lineTo(
        indicatorOffset.dx + s * 0.6,
        indicatorOffset.dy - s * 0.4,
      );
      canvas.drawPath(checkPath, checkPaint);
    } else if (isActive) {
      final Paint bgPaint = Paint()
        ..color = primaryColor.withOpacity(0.1)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius + 4, bgPaint);

      final Paint borderPaint = Paint()
        ..color = primaryColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(indicatorOffset, indicatorRadius, borderPaint);

      final Paint dotPaint = Paint()
        ..color = primaryColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(indicatorOffset, indicatorRadius * 0.42, dotPaint);
    } else {
      final Paint borderPaint = Paint()
        ..color = inactiveColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(indicatorOffset, indicatorRadius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StepperItemCanvas old) =>
      old.isActive != isActive ||
      old.isCheck != isCheck ||
      old.headerHeight != headerHeight;
}

// ─────────────────────────────────────────────
// HEADER STEPPER CONTAINER
// ─────────────────────────────────────────────

class HeaderStepperContainerWidget extends StatelessWidget {
  final bool isActive;
  final bool isCheck;

  /// Icon hiển thị ở leading (vd: Icons.calendar_today)
  final IconData icon;

  /// Widget nội dung bên cạnh icon — hoàn toàn tùy chỉnh
  final Widget child;

  /// Widget trailing tuỳ chọn, mặc định là chevron / check
  final Widget? trailing;

  final VoidCallback? onTap;

  const HeaderStepperContainerWidget({
    super.key,
    required this.isActive,
    required this.isCheck,
    required this.icon,
    required this.child,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final Color borderColor = isActive ? cs.primary : cs.outlineVariant;

    final Color bgColor = isActive ? cs.primaryContainer : cs.surface;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          // color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderColor,
            // width: isActive ? 1.5 : 1,
            width: 2,
          ),
          boxShadow: isActive ? cs.softShadow : null,
        ),
        child: Row(
          children: [
            // ── Leading icon ─────────────────
            _LeadingIcon(icon: icon, isActive: isActive, isCheck: isCheck),
            const SizedBox(width: 12),
            // ── Custom child ─────────────────
            Expanded(child: child),
            // ── Trailing ─────────────────────
            const SizedBox(width: 8),
            trailing ?? _DefaultTrailing(isActive: isActive, isCheck: isCheck),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// LEADING ICON
// ─────────────────────────────────────────────

class _LeadingIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isCheck;

  const _LeadingIcon({
    required this.icon,
    required this.isActive,
    required this.isCheck,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final Color bg = isActive
        ? cs.primary
        : isCheck
        ? cs.primaryContainer
        : cs.surfaceContainerHigh;

    final Color fg = isActive
        ? cs.onPrimary
        : isCheck
        ? cs.primary
        : cs.onSurfaceVariant;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(child: Icon(icon, color: fg, size: 18)),
    );
  }
}

// ─────────────────────────────────────────────
// DEFAULT TRAILING
// ─────────────────────────────────────────────

class _DefaultTrailing extends StatelessWidget {
  final bool isActive;
  final bool isCheck;

  const _DefaultTrailing({required this.isActive, required this.isCheck});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (isCheck) {
      return Icon(Icons.check_circle_rounded, color: cs.primary, size: 18);
    }
    return Icon(
      Icons.chevron_right_rounded,
      color: isActive ? cs.primary : cs.outlineVariant,
      size: 20,
    );
  }
}

// ─────────────────────────────────────────────
// STEP BODY CONTAINER
// ─────────────────────────────────────────────

class StepBodyContainer extends StatelessWidget {
  final Widget child;

  const StepBodyContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────
// MEASURE SIZE UTILITY
// ─────────────────────────────────────────────

typedef OnWidgetSizeChange = void Function(Size size);

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({super.key, required this.onChange, required Widget child})
    : super(child: child);

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureSize(onChange);
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
    WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
  }
}
