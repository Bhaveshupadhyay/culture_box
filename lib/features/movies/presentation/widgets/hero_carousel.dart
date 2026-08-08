import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../data/models/movie.dart';
import '../pages/details_page.dart';

class HeroCarousel extends StatefulWidget {
  final List<Movie> movies;

  const HeroCarousel({
    super.key,
    required this.movies,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: AppSpacing.px520,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.movies.length,
            itemBuilder: (context, index) {
              final movie = widget.movies[index];
              return _buildHeroItem(movie);
            },
          ),
        ),
        AppSpacing.vGap12,
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.movies.length, (index) {
            final isSelected = index == _currentIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: AppSpacing.px4),
              height: AppSpacing.px8,
              width: isSelected ? AppSpacing.px32 : AppSpacing.px8,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.logoGold : Colors.white24,
                borderRadius: BorderRadius.circular(AppSpacing.px4),
              ),
            );
          }),
        ),
        AppSpacing.vGap20,
      ],
    );
  }

  Widget _buildHeroItem(Movie movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(movieId: movie.id),
          ),
        );
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop image
          AppNetworkImage(
            imageUrl: movie.effectiveBackdrop,
            fit: BoxFit.cover,
          ),
          // Gradient overlays
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black,
                ],
                stops: const [0.0, 0.25, 0.75, 1.0],
              ),
            ),
          ),
          // Content
          Positioned(
            bottom: AppSpacing.px24,
            left: AppSpacing.px16,
            right: AppSpacing.px16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (movie.isOriginal)
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.px8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.px8, vertical: AppSpacing.px4),
                    decoration: BoxDecoration(
                      gradient: AppColors.buttonGradient,
                      borderRadius: BorderRadius.circular(AppSpacing.px4),
                    ),
                    child: Text(
                      'NETWORK ORIGINAL',
                      style: AppTextStyles.badgeText.copyWith(color: Colors.black, fontWeight: FontWeight.w900),
                    ),
                  ),
                Text(
                  movie.title,
                  style: AppTextStyles.heroTitle,
                ),
                AppSpacing.vGap8,
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.px8, vertical: AppSpacing.px4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(AppSpacing.px4),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star,
                              color: AppColors.logoGold, size: 14),
                          AppSpacing.hGap4,
                          Text(
                            movie.voteAverage.toStringAsFixed(1),
                            style: AppTextStyles.badgeRating,
                          ),
                        ],
                      ),
                    ),
                    if (movie.year != null) ...[
                      AppSpacing.hGap10,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.px10, vertical: AppSpacing.px4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(AppSpacing.px4),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          '${movie.year}',
                          style: AppTextStyles.badgeMeta,
                        ),
                      ),
                    ],
                  ],
                ),
                AppSpacing.vGap10,
                Text(
                  movie.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySecondary,
                ),
                AppSpacing.vGap16,
                Container(
                  width: double.infinity,
                  height: AppSpacing.px46,
                  decoration: BoxDecoration(
                    gradient: AppColors.buttonGradient,
                    borderRadius: BorderRadius.circular(AppSpacing.px8),
                  ),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.px8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsPage(movieId: movie.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow,
                        color: Colors.black, size: 24),
                    label: Text(
                      'WATCH NOW',
                      style: AppTextStyles.buttonTextDark,
                    ),
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
