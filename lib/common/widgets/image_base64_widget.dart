import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageBase64Widget extends StatefulWidget {
  final String base64String;

  /// Kích thước hiển thị (null = full width)
  final double? width;
  final double? height;

  /// Bo góc
  final double borderRadius;

  /// BoxFit cho ảnh
  final BoxFit fit;

  /// Widget hiển thị khi đang decode
  final Widget? loadingWidget;

  /// Widget hiển thị khi lỗi (null = dùng default)
  final Widget? errorWidget;

  const ImageBase64Widget({
    super.key,
    required this.base64String,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<ImageBase64Widget> createState() => _ImageBase64WidgetState();
}

class _ImageBase64WidgetState extends State<ImageBase64Widget> {
  Uint8List? _imageBytes;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _decodeBase64();
  }

  @override
  void didUpdateWidget(covariant ImageBase64Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.base64String != widget.base64String) {
      _decodeBase64();
    }
  }

  void _decodeBase64() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _imageBytes = null;
    });

    try {
      if (widget.base64String.trim().isEmpty) {
        setState(() {
          _errorMessage = 'Chuỗi base64 trống';
          _isLoading = false;
        });
        return;
      }

      // Xử lý cả dạng data URI: "data:image/png;base64,xxxx"
      String raw = widget.base64String.trim();
      if (raw.contains(',')) {
        raw = raw.split(',').last;
      }

      // Normalize: thêm padding nếu thiếu
      final padded = base64.normalize(raw);
      final bytes = base64Decode(padded);

      if (bytes.isEmpty) {
        setState(() {
          _errorMessage = 'Dữ liệu ảnh rỗng sau khi decode';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _imageBytes = bytes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Không thể decode ảnh';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    // ── Loading ──────────────────────────────────────────────────────────────
    if (_isLoading) {
      return widget.loadingWidget ?? _defaultLoading();
    }

    // ── Error ────────────────────────────────────────────────────────────────
    if (_errorMessage != null || _imageBytes == null) {
      return widget.errorWidget ?? _defaultError();
    }

    // ── Image ────────────────────────────────────────────────────────────────
    // return CachedMemoryImage(uniqueKey: uniqueKey)
    return Image.memory(
      _imageBytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      // Bắt lỗi render ảnh (sai format, corrupt…)
      errorBuilder: (_, error, __) =>
          _defaultError(message: 'Định dạng ảnh không hợp lệ'),
    );
  }

  // ── DEFAULT LOADING ──────────────────────────────────────────────────────────
  Widget _defaultLoading() {
    return Container(
      color: Colors.grey.shade100,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  // ── DEFAULT ERROR ────────────────────────────────────────────────────────────
  Widget _defaultError({String? message}) {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.broken_image_rounded,
                size: 36,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                message ?? _errorMessage ?? 'Không thể hiển thị ảnh',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
