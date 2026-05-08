import 'dart:async';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String hint;
  final Function(String)? onChanged;
  final Function(String)? onDebouncedChanged;
  final VoidCallback? onSearchIcon;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final Function(String)? onSubmitted;

  const SearchBarWidget({
    super.key,
    this.controller,
    required this.hint,
    this.onChanged,
    this.onDebouncedChanged,
    this.onSearchIcon,
    this.enabled = true,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.onSubmitted,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _ctrl;
  Timer? _searchTimer;
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(covariant SearchBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _ctrl = widget.controller ?? TextEditingController();
    }
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    _focusNode.dispose();
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  void _onSubmitted(String value) => widget.onSubmitted?.call(value);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isFocused ? cs.primaryContainer : cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        margin: const EdgeInsets.all(3),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(13),
          // border: Border.all(
          //   color: _isFocused
          //       ? cs.primary.withOpacity(0.4)
          //       : Colors.transparent,
          //   width: 1,
          // ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enabled: widget.enabled,
                keyboardType: widget.keyboardType,
                focusNode: _focusNode,
                controller: _ctrl,
                textAlign: widget.textAlign,
                onSubmitted: _onSubmitted,
                onChanged: (value) {
                  widget.onChanged?.call(value);
                  if (widget.onDebouncedChanged != null) {
                    _searchTimer?.cancel();
                    _searchTimer = Timer(
                      const Duration(milliseconds: 300),
                      () => widget.onDebouncedChanged!(value),
                    );
                  }
                  setState(() {});
                },
                // decoration: InputDecoration(
                //   hintText: widget.hint,
                //   hintStyle: tt.bodyMedium?.copyWith(
                //     color: cs.onSurfaceVariant,
                //   ),
                //   border: InputBorder.none,
                //   contentPadding: const EdgeInsets.symmetric(
                //     horizontal: 16,
                //     vertical: 12,
                //   ),
                // ),
                decoration: InputDecoration(
                  hintText: widget.hint,
                  hintStyle: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),

                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,

                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                ),
                style: tt.bodyMedium?.copyWith(color: cs.onSurface),
              ),
            ),

            // Clear button — hiện khi có text
            if (_ctrl.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  _ctrl.clear();
                  widget.onChanged?.call('');
                  widget.onDebouncedChanged?.call('');
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ),

            // Search button
            GestureDetector(
              onTap: widget.onSearchIcon ?? () => _onSubmitted(_ctrl.text),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(
                  color: _isFocused
                      ? cs.primaryContainer
                      : cs.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.search_rounded,
                  color: _isFocused ? cs.primary : cs.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
