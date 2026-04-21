import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String? base64;
  final double size;
  final BoxDecoration? boxDecoration;
  final String? initialLetter; // Thêm chữ cái đầu
  final Color? backgroundColor; // Màu nền cho avatar chữ cái
  final Color? textColor; // Màu chữ
  final bool showBorder; // Hiển thị viền
  final Color borderColor; // Màu viền
  final double borderRadius; // Màu viền

  const AvatarWidget({
    super.key,
    this.base64,
    this.size = 70,
    this.boxDecoration,
    this.initialLetter,
    this.backgroundColor,
    this.textColor,
    this.showBorder = false,
    this.borderColor = const Color(0xFF1469AE),
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration:
          boxDecoration ??
          BoxDecoration(
            // shape: BoxShape.circle,
            borderRadius: BorderRadius.circular(borderRadius),
            border: showBorder
                ? Border.all(color: borderColor, width: 2)
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
      child: _buildAvatarContent(),
    );
  }

  Widget _buildAvatarContent() {
    // Nếu có base64, hiển thị ảnh
    if (base64 != null && base64!.isNotEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(12),
        ),
        child: CachedMemoryImage(
          uniqueKey: 'avatar_$base64',
          base64: base64,
          width: size,
          height: size,
          fit: BoxFit.cover,
          placeholder: _buildPlaceholder(),
          errorWidget: _buildInitialOrIcon(),
        ),
      );
    }

    // Không có ảnh, hiển thị chữ cái hoặc icon
    return _buildInitialOrIcon();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        // shape: BoxShape.circle,
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildInitialOrIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: backgroundColor != null
            ? null
            : LinearGradient(
                colors: [
                  Color(0xFF4A8FE7).withOpacity(0.1),
                  Color(0xFF2E7BCE).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        // shape: BoxShape.circle,
      ),
      child: Center(
        child: initialLetter != null && initialLetter!.isNotEmpty
            ? Text(
                initialLetter!.toUpperCase(),
                style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Color(0xFF1469AE),
                ),
              )
            : Icon(
                Icons.person,
                color: textColor ?? Colors.grey[400],
                size: size * 0.5,
              ),
      ),
    );
  }
}
