import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../app/theme/app_theme.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorWidget,
  });

  /// Formats relative image URLs (e.g., 'uploads/...') into full Cloudinary CDN URLs
  static String formatImageUrl(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    // Prepend Cloudinary CDN base path as per cbn_doc.md spec
    return 'https://res.cloudinary.com/dwyflu02w/image/upload/c_fill,g_auto,w_1280,h_720,q_auto,f_auto/$trimmed';
  }

  @override
  Widget build(BuildContext context) {
    final String formattedUrl = formatImageUrl(imageUrl);

    if (formattedUrl.isEmpty) {
      return _buildErrorWidget(context);
    }

    return CachedNetworkImage(
      imageUrl: formattedUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.surface,
        highlightColor: AppColors.surfaceSecondary,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          color: AppColors.surface,
        ),
      ),
      errorWidget: (context, url, error) => errorWidget ?? _buildErrorWidget(context),
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: AppColors.surface,
      child: const Center(
        child: Icon(Icons.movie, size: 40, color: Colors.white24),
      ),
    );
  }
}
