import 'package:flutter/material.dart';

class SwipedWidget extends StatefulWidget {
  const SwipedWidget({
    super.key,
    this.enable = true,
    required this.actions,
    required this.child,
    this.actionExtent = 68,
    this.borderRadius,
  });

  final bool enable;
  final List<SwipedActionWidget> actions;
  final Widget child;
  final double actionExtent;
  final BorderRadius? borderRadius;

  @override
  State<SwipedWidget> createState() => _SwipedWidgetState();
}

class _SwipedWidgetState extends State<SwipedWidget> {
  double _offsetX = 0;

  double get _maxSlide => widget.actions.length * widget.actionExtent;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _offsetX = (_offsetX + details.delta.dx).clamp(-_maxSlide, 0);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      _offsetX = _offsetX < -_maxSlide / 2 ? -_maxSlide : 0;
    });
  }

  void _close() {
    if (_offsetX == 0) return;
    setState(() => _offsetX = 0);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: widget.actions
                    .map(
                      (action) => SizedBox(
                        width: widget.actionExtent,
                        height: double.infinity,
                        child: action,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          GestureDetector(
            onTap: _close,
            onHorizontalDragUpdate:
                widget.enable ? _onHorizontalDragUpdate : null,
            onHorizontalDragEnd: widget.enable ? _onHorizontalDragEnd : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(_offsetX, 0, 0),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class SwipedActionWidget extends StatelessWidget {
  const SwipedActionWidget({
    super.key,
    required this.onTap,
    required this.color,
    required this.child,
  });

  final VoidCallback onTap;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Center(child: child),
      ),
    );
  }
}
