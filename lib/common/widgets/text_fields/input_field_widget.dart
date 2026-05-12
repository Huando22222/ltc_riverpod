import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class InputFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final bool isPassword;
  final bool isShowLabel;
  final bool isShowHint;
  final bool isEnable;
  final TextStyle? labelStyle;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  const InputFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.icon,
    this.isPassword = false,
    this.isShowLabel = true,
    this.isShowHint = false,
    this.isEnable = true,
    this.labelStyle,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });

  @override
  State<InputFieldWidget> createState() => _InputFieldWidgetState();
}

class _InputFieldWidgetState extends State<InputFieldWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowLabel) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              widget.label,
              // ✅ labelStyle hoặc bodyMedium với onSurface thay vì default (có thể inherit sai màu)
              style:
                  widget.labelStyle ??
                  tt.bodyMedium?.copyWith(color: cs.onSurface),
            ),
          ),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            // ✅ surface thay vì Colors.white / Colors.grey[100]
            color: widget.isEnable ? cs.surface : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd + 2),
            border: Border.all(
              // ✅ outline thay vì outline.withOpacity(0.4) — đã đủ nhạt theo schema
              color: _isFocused ? cs.primary : cs.outline,
              width: _isFocused ? 1.5 : 1,
            ),
            boxShadow: _isFocused ? cs.softShadow : null,
          ),
          child: TextField(
            onChanged: widget.onChanged,
            enabled: widget.isEnable,
            focusNode: _focusNode,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            style: tt.bodyMedium?.copyWith(
              // ✅ onSurface thay vì Colors.grey[800]
              color: cs.onSurface,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.isShowHint ? widget.hint ?? widget.label : null,
              hintStyle: tt.bodyMedium?.copyWith(
                // ✅ textDisabled (onSurfaceVariant) thay vì Colors.grey[400]
                color: cs.onSurfaceVariant,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.icon != null
                  ? Container(
                      margin: const EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        widget.icon,
                        // ✅ onSurfaceVariant khi idle, primary khi focused
                        color: _isFocused ? cs.primary : cs.onSurfaceVariant,
                        size: 22,
                      ),
                    )
                  : null,
              suffixIcon: widget.isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        // ✅ onSurfaceVariant thay vì Colors.grey[400]
                        color: cs.onSurfaceVariant,
                        size: 22,
                      ),
                      onPressed: () =>
                          setState(() => _obscureText = !_obscureText),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: widget.icon != null ? 8 : 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
