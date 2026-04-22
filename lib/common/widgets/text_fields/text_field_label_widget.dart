import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldLabelWidget extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final bool isOptional;
  final bool enabled;
  final String? valueText;
  final bool readOnly;
  final EdgeInsets contentPadding;
  final double iconSize;
  final double borderRadius;
  final TextStyle? labelStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? errorWidget;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSuffixIconTap;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final bool obscureText;
  const TextFieldLabelWidget({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.isOptional = false,
    this.enabled = true,
    this.valueText,
    this.readOnly = false,
    this.iconSize = 18,
    this.borderRadius = 8,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 0,
    ),
    this.inputFormatters,
    this.errorWidget,
    this.onChanged,
    this.onSubmitted,
    this.onSuffixIconTap,
    this.onTap,
    this.labelStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.focusNode,
    this.maxLines = 1,
    this.minLines = 1,
    this.obscureText = false,
  });

  @override
  State<TextFieldLabelWidget> createState() => _TextFieldLabelWidgetState();
}

class _TextFieldLabelWidgetState extends State<TextFieldLabelWidget> {
  static const Color _defaultFocus = Color(0xFF1469AE);

  late FocusNode _focusNode;
  bool _isExternalFocusNode = false;
  bool _isFocused = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _isExternalFocusNode = true;
    } else {
      _focusNode = FocusNode();
    }
    _focusNode.addListener(() {
      if (mounted) setState(() => _isFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    if (!_isExternalFocusNode) _focusNode.dispose();
    super.dispose();
  }

  // ── State helpers ─────────────────────────────────────────
  bool get _hasError => _errorMessage != null && _errorMessage!.isNotEmpty;

  Color get _activeFocus => widget.focusedBorderColor ?? _defaultFocus;

  Color get _borderColor {
    if (!widget.enabled) return Colors.grey.shade200;
    if (_hasError) return Colors.red.shade400;
    if (_isFocused) return _activeFocus;
    return widget.borderColor ?? Colors.grey.shade200;
  }

  Color get _iconColor {
    if (!widget.enabled) return Colors.grey.shade300;
    if (_hasError) return Colors.red.shade400;
    if (_isFocused) return _activeFocus;
    return Colors.grey.shade400;
  }

  Color get _resolvedFill {
    if (!widget.enabled) return Colors.grey.shade50;
    if (_hasError) return Colors.red.shade50;
    return widget.fillColor ?? Colors.white;
  }

  // ── Build ─────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ───────────────────────────────────────────
        Row(
          children: [
            Text(
              widget.label,
              style:
                  widget.labelStyle ??
                  TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _isFocused && !_hasError
                        ? _activeFocus
                        : Colors.grey.shade600,
                    letterSpacing: 0.2,
                  ),
            ),
            if (widget.isOptional) ...[
              const SizedBox(width: 4),
              Text(
                '(tuỳ chọn)',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 6),

        // ── Input container ──────────────────────────────────
        GestureDetector(
          onTap: widget.enabled && widget.onTap != null ? widget.onTap : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            // height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _resolvedFill,
              border: Border.all(
                color: _borderColor,
                width: _isFocused || _hasError ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Row(
              children: [
                // Prefix icon
                if (widget.prefixIcon != null) ...[
                  Icon(
                    widget.prefixIcon!,
                    size: widget.iconSize,
                    color: _iconColor,
                  ),
                  const SizedBox(width: 8),
                ],

                // Field / display text
                Expanded(
                  child: widget.valueText != null
                      ? Text(
                          widget.valueText!.isNotEmpty
                              ? widget.valueText!
                              : (widget.hintText ?? ''),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: widget.valueText!.isNotEmpty
                                ? Colors.black87
                                : Colors.grey.shade400,
                          ),
                        )
                      : AbsorbPointer(
                          absorbing: widget.readOnly || widget.onTap != null,
                          child: TextFormField(
                            obscureText: widget.obscureText,
                            readOnly: widget.readOnly,
                            focusNode: _focusNode,
                            enabled: widget.enabled,
                            controller: widget.controller,
                            keyboardType: widget.keyboardType,
                            inputFormatters: widget.inputFormatters,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A1A2E),
                            ),
                            onChanged: widget.onChanged,
                            onFieldSubmitted: widget.onSubmitted,
                            validator: (value) {
                              final error = widget.validator?.call(value);
                              if (_errorMessage != error) {
                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  if (mounted) {
                                    setState(() => _errorMessage = error);
                                  }
                                });
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: widget.hintText,
                              hintStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              errorStyle: const TextStyle(height: 0),
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                            ),
                            maxLines: widget.maxLines,
                            minLines: widget.minLines,
                          ),
                        ),
                ),

                // Suffix icon
                if (widget.suffixIcon != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: widget.onSuffixIconTap,
                    child: AnimatedRotation(
                      duration: const Duration(milliseconds: 200),
                      turns: _isFocused ? 0.5 : 0,
                      child: Icon(
                        widget.suffixIcon!,
                        size: widget.iconSize,
                        color: _iconColor,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // ── Error message ────────────────────────────────────
        if (_hasError) ...[
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(Icons.error_outline, size: 13, color: Colors.red.shade400),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  _errorMessage!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.red.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
// ErrorFormFieldMessagingWidget — giữ nguyên
// ════════════════════════════════════════════════════════════
class ErrorFormFieldMessagingWidget extends StatelessWidget {
  final String message;
  const ErrorFormFieldMessagingWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 13, color: Colors.red.shade400),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 11,
                color: Colors.red.shade400,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
