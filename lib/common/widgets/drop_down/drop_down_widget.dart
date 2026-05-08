import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';

class DropDownWidget extends StatefulWidget {
  final List<dynamic> categories;
  final String? selectedCategory;
  final Function(String?) onChanged;
  final double? dropdownWidth;
  final bool fitContentWidth;
  final double paddingMain;
  final Map<String, IconData>? customIcons;

  const DropDownWidget({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
    this.dropdownWidth,
    this.fitContentWidth = false,
    this.paddingMain = 16,
    this.customIcons,
  });

  @override
  _DropDownWidgetState createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;
  final GlobalKey _key = GlobalKey();
  OverlayEntry? _overlayEntry;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  String _getItemText(dynamic item) {
    if (item is String) return item;
    return '';
  }

  IconData? _getIconForItem(String text, int index) {
    if (widget.customIcons != null && widget.customIcons!.containsKey(text)) {
      return widget.customIcons![text];
    }
    if (index == 0) return Icons.apps_rounded;
    if (text.toLowerCase() == 'gói dịch vụ') return FontAwesomeIcons.boxOpen;
    if (text.toLowerCase() == 'xét nghiệm') return FontAwesomeIcons.flask;
    return null;
  }

  void _toggleDropdown() => isOpen ? _closeDropdown() : _openDropdown();

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => isOpen = true);
    _animationController.forward();
  }

  void _closeDropdown() {
    _animationController.reverse().then((_) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    });
    setState(() => isOpen = false);
  }

  double _calculateDropdownWidth(RenderBox renderBox) {
    if (widget.dropdownWidth != null) return widget.dropdownWidth!;
    if (widget.fitContentWidth) {
      double maxWidth = 0;
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        maxLines: 1,
      );
      for (var category in widget.categories) {
        String text = _getItemText(category);
        textPainter.text = TextSpan(
          text: text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        );
        textPainter.layout();
        double categoryWidth =
            textPainter.width +
            (widget.paddingMain * 2) +
            12 +
            8 +
            12 +
            18 +
            20;
        if (categoryWidth > maxWidth) maxWidth = categoryWidth;
      }
      double buttonWidth = renderBox.size.width;
      return math.max(buttonWidth, math.min(maxWidth, 400));
    }
    return renderBox.size.width;
  }

  // Palette warna dot — tidak hardcode, pakai colorScheme-inspired hues
  static const _dotColors = [
    Color(0xFF6366F1),
    Color(0xFFEF4444),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF06B6D4),
    Color(0xFF84CC16),
    Color(0xFFF97316),
    Color(0xFF6B7280),
    Color(0xFF14B8A6),
    Color(0xFFD946EF),
    Color(0xFF3B82F6),
    Color(0xFFEAB308),
    Color(0xFF22D3EE),
  ];

  OverlayEntry _createOverlayEntry() {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final buttonSize = renderBox.size;
    final buttonOffset = renderBox.localToGlobal(Offset.zero);
    final dropdownWidth = _calculateDropdownWidth(renderBox);

    final screenSize = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    double left = buttonOffset.dx;
    if (widget.fitContentWidth) {
      left = buttonOffset.dx - (dropdownWidth - buttonSize.width) / 2;
    }
    if (left < 16) {
      left = 16;
    } else if (left + dropdownWidth > screenSize.width - 16) {
      left = screenSize.width - dropdownWidth - 16;
    }

    double? topPosition;
    double? bottomPosition;
    final sizeAbove = buttonOffset.dy - padding.top;
    final sizeBelow =
        screenSize.height -
        buttonOffset.dy -
        (buttonSize.height + 8) -
        padding.bottom;

    double dropdownHeight;
    if (sizeAbove > sizeBelow) {
      dropdownHeight = sizeAbove;
      topPosition = padding.top;
    } else {
      dropdownHeight = sizeBelow;
      bottomPosition = padding.bottom;
    }

    return OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) => Stack(
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                child: Container(
                  color: cs.scrim.withOpacity(0.3 * _fadeAnimation.value),
                ),
              ),
            ),
            // Dropdown panel
            Positioned(
              left: left,
              top: topPosition,
              bottom: bottomPosition,
              child: SizedBox(
                height: dropdownHeight,
                child: Column(
                  mainAxisAlignment: bottomPosition == null
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Transform.scale(
                      scale: 0.95 + (0.05 * _fadeAnimation.value),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Material(
                          elevation: 0,
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.transparent,
                          child: Container(
                            width: dropdownWidth,
                            constraints: BoxConstraints(
                              maxHeight: dropdownHeight,
                            ),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: cs.outlineVariant),
                              boxShadow: [
                                BoxShadow(
                                  color: cs.shadow,
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Scrollbar(
                                thickness: 3,
                                radius: const Radius.circular(2),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: widget.categories.asMap().entries.map((
                                      entry,
                                    ) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      final text = _getItemText(item);
                                      final isSelected =
                                          widget.selectedCategory == text;
                                      final icon = _getIconForItem(text, index);

                                      return InkWell(
                                        onTap: () {
                                          widget.onChanged(text);
                                          _closeDropdown();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          color: isSelected
                                              ? cs.surfaceContainerHigh
                                              : null,
                                          child: Row(
                                            children: [
                                              // Icon hoặc color dot
                                              if (icon != null)
                                                Icon(
                                                  icon,
                                                  size: 16,
                                                  color: isSelected
                                                      ? cs.primary
                                                      : cs.onSurfaceVariant,
                                                )
                                              else
                                                Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        _dotColors[index %
                                                            _dotColors.length],
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: item is Widget
                                                    ? item
                                                    : Text(
                                                        text,
                                                        style: tt.bodyMedium
                                                            ?.copyWith(
                                                              color: isSelected
                                                                  ? cs.primary
                                                                  : cs.onSurface,
                                                              fontWeight:
                                                                  isSelected
                                                                  ? FontWeight
                                                                        .w600
                                                                  : FontWeight
                                                                        .w500,
                                                            ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.check_rounded,
                                                  color: cs.primary,
                                                  size: 18,
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final selectedText = widget.selectedCategory ?? '';
    final selectedIndex = widget.categories.indexWhere(
      (item) => _getItemText(item) == selectedText,
    );
    final selectedIcon = selectedIndex >= 0
        ? _getIconForItem(selectedText, selectedIndex)
        : null;

    return GestureDetector(
      key: _key,
      onTap: _toggleDropdown,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isOpen ? cs.primary : cs.outline,
            width: isOpen ? 1.5 : 1,
          ),
          boxShadow: cs.softShadow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              selectedIcon ?? Icons.apps_rounded,
              color: isOpen ? cs.primary : cs.onSurfaceVariant,
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.selectedCategory ?? 'Chọn danh mục',
                style: tt.bodyMedium?.copyWith(
                  color: widget.selectedCategory == null
                      ? cs.onSurfaceVariant
                      : cs.onSurface,
                  fontWeight: widget.selectedCategory != null
                      ? FontWeight.w500
                      : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AnimatedRotation(
              turns: isOpen ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: isOpen ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
