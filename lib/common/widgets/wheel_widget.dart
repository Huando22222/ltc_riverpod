import 'package:flutter/material.dart';

/// [WheelWidget] should be wrapped in a [Expanded] if used inside a [Row].
///
/// Để tránh lỗi tự scroll khi parent setState, hãy truyền [controller] từ bên ngoài.
/// Khi dùng [controller], [initialIndex] sẽ bị bỏ qua.
///
/// Ví dụ:
/// ```dart
/// final ctrl = FixedExtentScrollController(initialItem: 2);
/// WheelWidget(controller: ctrl, items: [...], onSelectedChanged: (i) {});
/// ```
class WheelWidget extends StatefulWidget {
  final List<Widget> items;
  final double? height;
  final double itemExtent;
  final void Function(int)? onSelectedChanged;
  final int initialIndex;
  final bool isInfinite;

  /// Truyền controller từ bên ngoài để kiểm soát scroll mà không gây rebuild loop.
  final FixedExtentScrollController? controller;

  const WheelWidget({
    super.key,
    required this.items,
    this.height,
    this.itemExtent = 50,
    this.onSelectedChanged,
    this.initialIndex = 0,
    this.isInfinite = false,
    this.controller,
  });

  @override
  State<WheelWidget> createState() => _WheelWidgetState();
}

class _WheelWidgetState extends State<WheelWidget> {
  static const int _loopMultiplier = 1000;

  FixedExtentScrollController? _internalController;
  late int _selectedIndex;

  /// Dùng controller bên ngoài nếu có, không thì dùng internal
  FixedExtentScrollController get _scrollController =>
      widget.controller ?? _internalController!;

  bool get _usingExternalController => widget.controller != null;

  List<Widget> get _effectiveItems {
    if (widget.isInfinite) {
      return List.generate(
        widget.items.length * _loopMultiplier,
        (i) => widget.items[i % widget.items.length],
      );
    }
    return widget.items;
  }

  int get _realItemCount => widget.items.length;

  int _resolveIndex(int logicalIndex) {
    return widget.isInfinite
        ? (_realItemCount * _loopMultiplier ~/ 2) + logicalIndex
        : logicalIndex;
  }

  @override
  void initState() {
    super.initState();

    _selectedIndex = _resolveIndex(widget.initialIndex);

    // Chỉ tạo internal controller nếu không có external controller
    if (!_usingExternalController) {
      _internalController = FixedExtentScrollController(
        initialItem: _selectedIndex,
      );
    } else {
      // Lấy selected index từ external controller
      _selectedIndex = widget.controller!.initialItem;
    }
  }

  @override
  void didUpdateWidget(WheelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ── Nếu dùng external controller: KHÔNG làm gì ──
    // Parent tự gọi jumpToItem/animateToItem khi cần.
    // Tránh hoàn toàn vòng lặp rebuild → scroll.
    if (_usingExternalController) return;

    // ── Nếu dùng internal controller ──
    // Chỉ scroll khi items list thay đổi kích thước (không phải mỗi setState)
    final itemsChanged = widget.items.length != oldWidget.items.length;
    if (!itemsChanged) return;

    final newIndex = _resolveIndex(widget.initialIndex);
    if (newIndex == _selectedIndex) return;

    _selectedIndex = newIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpToItem(_selectedIndex);
      }
    });
  }

  @override
  void dispose() {
    // Chỉ dispose internal controller, không dispose external
    _internalController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = _effectiveItems;

    return SizedBox(
      height: widget.height ?? 200,
      child: ListWheelScrollView.useDelegate(
        controller: _scrollController,
        itemExtent: widget.itemExtent,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: (index) {
          setState(() {
            _selectedIndex = index;
            final realIndex = widget.isInfinite
                ? index % _realItemCount
                : index;
            widget.onSelectedChanged?.call(realIndex);
          });
        },
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: items.length,
          builder: (context, index) {
            final isSelected = index == _selectedIndex;
            return Center(
              child: AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.4,
                duration: const Duration(milliseconds: 200),
                child: AnimatedScale(
                  scale: isSelected ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: items[index],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
