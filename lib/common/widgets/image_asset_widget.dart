import 'package:flutter/material.dart';
import '../../core/constants/image_path_constants.dart';

class ImageAssetWidget extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final Widget? errorWidget;

  const ImageAssetWidget({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.fit = BoxFit.cover,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          assetPath,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, __, ___) => errorWidget ?? _buildError(),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Image.asset(
      ImagePathConstants.placeholder, // fallback về placeholder
      width: width,
      height: height,
      fit: fit,
      // Nếu placeholder cũng lỗi → hiện icon
      errorBuilder: (_, __, ___) => _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: Colors.grey.shade100,
      child: Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          size: 36,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
