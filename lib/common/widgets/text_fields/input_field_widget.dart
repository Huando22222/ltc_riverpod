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
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isShowLabel) ...[
          Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              widget.label,
              style: widget.labelStyle ?? context.textTheme.bodyMedium,
            ),
          ),
        ],
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: widget.isEnable ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd + 2),
            border: Border.all(
              color: _isFocused
                  ? context.colorScheme.primary
                  : context.colorScheme.outline.withOpacity(0.4),
              width: 2,
            ),
            boxShadow: _isFocused ? context.colorScheme.softShadow : null,
          ),
          child: TextField(
            enabled: widget.isEnable,
            focusNode: _focusNode,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.isPassword ? _obscureText : false,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              hintText: widget.isShowHint ? widget.hint ?? widget.label : null,
              hintStyle: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: widget.icon != null
                  ? Container(
                      margin: EdgeInsets.only(left: 12, right: 8),
                      child: Icon(
                        widget.icon,
                        //  color: iconColor,
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
                        color: Colors.grey[400],
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
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
