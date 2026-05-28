import 'package:flutter/material.dart';
import 'package:ltc/core/extensions/context_ext.dart';
import 'package:ltc/core/theme/app_spacing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeWidget extends StatelessWidget {
  const QrCodeWidget({
    super.key,
    required this.data,
    this.size = 220,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.label,
    this.logo,
    this.logoSize = 42,
    this.foregroundColor,
    this.backgroundColor,
    this.showFrame = true,
    this.showShadow = false,
    this.minScannableSize = 120,
    this.allowUnsafeSmallSize = false,
    this.errorCorrectionLevel = QrErrorCorrectLevel.M,
    this.semanticsLabel,
  });

  final String data;
  final double size;
  final EdgeInsetsGeometry padding;
  final String? label;
  final ImageProvider? logo;
  final double logoSize;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final bool showFrame;
  final bool showShadow;
  final double minScannableSize;
  final bool allowUnsafeSmallSize;
  final int errorCorrectionLevel;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final trimmedData = data.trim();
    final colors = context.colorScheme;
    final qrColor = foregroundColor ?? colors.onSurface;
    final qrBackground = backgroundColor ?? colors.surface;
    final effectiveSize = allowUnsafeSmallSize || size >= minScannableSize
        ? size
        : minScannableSize;
    final effectiveLogoSize = logoSize <= 0 ? 0.0 : logoSize;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (trimmedData.isEmpty)
          _EmptyQrState(size: effectiveSize)
        else
          Semantics(
            label: semanticsLabel ?? label ?? 'QR code',
            image: true,
            child: QrImageView(
              data: trimmedData,
              version: QrVersions.auto,
              size: effectiveSize,
              gapless: false,
              backgroundColor: qrBackground,
              errorCorrectionLevel: errorCorrectionLevel,
              embeddedImage: logo,
              embeddedImageStyle: logo == null || effectiveLogoSize == 0
                  ? null
                  : QrEmbeddedImageStyle(size: Size.square(effectiveLogoSize)),
              eyeStyle: QrEyeStyle(eyeShape: QrEyeShape.square, color: qrColor),
              dataModuleStyle: QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: qrColor,
              ),
            ),
          ),
        if (label != null && label!.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            label!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodyMedium?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );

    if (!showFrame) return content;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: qrBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: showShadow ? context.softShadow : null,
      ),
      child: content,
    );
  }
}

class _EmptyQrState extends StatelessWidget {
  const _EmptyQrState({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(
          Icons.qr_code_2_rounded,
          size: size * .36,
          color: context.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
