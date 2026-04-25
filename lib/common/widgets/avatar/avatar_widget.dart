import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:ltc/common/widgets/images/network_image_widget.dart';
import 'package:ltc/core/extensions/color_schema_ext.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.base64,
    this.url,
    this.size = 48,
    this.borderRadius = AppSpacing.radiusMd,
    this.initialLetter,
    this.backgroundColor,
    this.textColor,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 2,
  });

  final String? base64;
  final String? url;
  final double size;
  final double borderRadius;
  final String? initialLetter;
  final Color? backgroundColor;
  final Color? textColor;
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: borderColor ?? context.colorScheme.primary,
                width: borderWidth,
              )
            : null,
        boxShadow: context.colorScheme.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(borderRadius),
        clipBehavior: Clip.hardEdge,
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // ── Ưu tiên base64 ────────────────────────────
    if (base64 != null && base64!.isNotEmpty) {
      return CachedMemoryImage(
        uniqueKey: 'avatar_$base64',
        base64: base64,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: _buildLoading(context),
        errorWidget: _buildFallback(context),
      );
    }

    // ── URL ───────────────────────────────────────
    if (url != null && url!.isNotEmpty) {
      return NetworkImageWidget(
        url: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorWidget: _buildFallback(context),
        loadingWidget: _buildLoading(context),
      );
    }

    // ── Fallback: chữ cái hoặc icon ───────────────
    return _buildFallback(context);
  }

  // ── Loading ───────────────────────────────────────
  Widget _buildLoading(BuildContext context) {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.colorScheme.primary.withOpacity(0.5),
        ),
      ),
    );
  }

  // ── Fallback: initial letter hoặc icon ────────────
  Widget _buildFallback(BuildContext context) {
    final bg = backgroundColor ?? context.colorScheme.primaryContainer;
    final fg = textColor ?? context.colorScheme.onPrimaryContainer;

    return Container(
      color: bg,
      child: Center(
        child: initialLetter != null && initialLetter!.isNotEmpty
            ? Text(
                initialLetter!.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              )
            : Icon(Icons.person_rounded, color: fg, size: size * 0.5),
      ),
    );
  }
}
