import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../app/theme/app_theme.dart';

/// Reusable Shimmer Container Wrapper
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Margin? margin;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1E1E1E),
      highlightColor: const Color(0xFF2E2E2E),
      child: Container(
        width: width,
        height: height,
        margin: margin != null
            ? EdgeInsets.only(
                left: margin!.left,
                top: margin!.top,
                right: margin!.right,
                bottom: margin!.bottom,
              )
            : null,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class Margin {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const Margin({this.left = 0, this.top = 0, this.right = 0, this.bottom = 0});
}

/// Shimmer Skeleton for HomePage - Exact matching Hero Carousel (520px) and MovieCard (144x201, 205px container)
class HomePageShimmer extends StatelessWidget {
  const HomePageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Carousel Backdrop Shimmer (Exact 520px height)
          const ShimmerBox(
            width: double.infinity,
            height: 520,
            borderRadius: 0,
          ),
          const SizedBox(height: 12),

          // Indicator Dots Shimmer
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ShimmerBox(width: 32, height: 8, borderRadius: 4),
              SizedBox(width: 8),
              ShimmerBox(width: 8, height: 8, borderRadius: 4),
              SizedBox(width: 8),
              ShimmerBox(width: 8, height: 8, borderRadius: 4),
            ],
          ),
          const SizedBox(height: 20),

          // Section 1 Header Shimmer (Matching MovieSection title + See All)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ShimmerBox(width: 140, height: 20, borderRadius: 4),
                ShimmerBox(width: 50, height: 16, borderRadius: 4),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Section 1 Horizontal Cards Shimmer (Exact MovieCard dimensions: 144w x 201h inside 205h container)
          SizedBox(
            height: 205,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ShimmerBox(
                    width: 144,
                    height: 201,
                    borderRadius: 10,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Section 2 Header Shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ShimmerBox(width: 180, height: 20, borderRadius: 4),
                ShimmerBox(width: 50, height: 16, borderRadius: 4),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Section 2 Horizontal Cards Shimmer
          SizedBox(
            height: 205,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 4,
              itemBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: ShimmerBox(
                    width: 144,
                    height: 201,
                    borderRadius: 10,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer Skeleton for Movie Details Page - Exact matching 380px backdrop and 44px buttons
class DetailsPageShimmer extends StatelessWidget {
  const DetailsPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Backdrop Shimmer (Exact 380px height)
          const ShimmerBox(
            width: double.infinity,
            height: 380,
            borderRadius: 0,
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meta Badges Shimmer Row
                Row(
                  children: const [
                    ShimmerBox(width: 50, height: 26, borderRadius: 6),
                    SizedBox(width: 8),
                    ShimmerBox(width: 50, height: 26, borderRadius: 6),
                    SizedBox(width: 8),
                    ShimmerBox(width: 60, height: 26, borderRadius: 6),
                    SizedBox(width: 8),
                    ShimmerBox(width: 70, height: 26, borderRadius: 6),
                    SizedBox(width: 8),
                    ShimmerBox(width: 60, height: 26, borderRadius: 6),
                  ],
                ),
                const SizedBox(height: 16),

                // Buttons Shimmer Row (Exact 44px height matching WATCH NOW & PLAY TRAILER)
                Row(
                  children: const [
                    Expanded(
                      child: ShimmerBox(width: double.infinity, height: 44, borderRadius: 8),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ShimmerBox(width: double.infinity, height: 44, borderRadius: 8),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Description Lines Shimmer
                const ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
                const SizedBox(height: 8),
                const ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
                const SizedBox(height: 8),
                const ShimmerBox(width: 240, height: 14, borderRadius: 4),
                const SizedBox(height: 16),

                // Detail Rows Shimmer
                const ShimmerBox(width: 180, height: 16, borderRadius: 4),
                const SizedBox(height: 8),
                const ShimmerBox(width: 220, height: 16, borderRadius: 4),
                const SizedBox(height: 8),
                const ShimmerBox(width: 150, height: 16, borderRadius: 4),
                const SizedBox(height: 32),

                // Related Section Title Shimmer
                const ShimmerBox(width: 140, height: 22, borderRadius: 4),
                const SizedBox(height: 12),

                // Related Movies Row Shimmer (144x200)
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: ShimmerBox(
                          width: 144,
                          height: 200,
                          borderRadius: 10,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer Skeleton Grid for Search Page
class SearchPageShimmer extends StatelessWidget {
  const SearchPageShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 10,
        );
      },
    );
  }
}

/// Shimmer Skeleton for Video Player Initialization
class VideoPlayerShimmer extends StatelessWidget {
  const VideoPlayerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF141414),
      highlightColor: const Color(0xFF2A2A2A),
      child: Stack(
        children: [
          // Center Video Player Frame Shimmer
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Top Bar Shimmer
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 180,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Bottom Bar Shimmer
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              width: double.infinity,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shimmer Loading Indicator for Buttons
class ButtonShimmerLoader extends StatelessWidget {
  final double width;
  final double height;

  const ButtonShimmerLoader({
    super.key,
    this.width = 80,
    this.height = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.logoRedOrange.withValues(alpha: 0.5),
      highlightColor: Colors.white,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
