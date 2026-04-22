import 'package:flutter/material.dart';
import '../../../core/constants/image_path_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class NetworkImageWidget extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const NetworkImageWidget({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(width: width, height: height, child: _buildImage()),
    );
  }

  Widget _buildImage() {
    // URL rỗng → hiện error ngay
    if (url == null || url!.trim().isEmpty) {
      return errorWidget ?? _buildPlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: url!,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) => loadingWidget ?? _buildLoading(),
      errorWidget: (_, __, ___) => errorWidget ?? _buildPlaceholder(),
    );
  }

  // ── DEFAULT LOADING ────────────────────────────────
  Widget _buildLoading() {
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

  // ── DEFAULT ERROR — dùng placeholder asset ─────────
  Widget _buildPlaceholder() {
    return Image.asset(
      ImagePathConstants.placeholder,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.broken_image_rounded,
          size: 36,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
