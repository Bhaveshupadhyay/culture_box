import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../data/models/movie.dart';
import '../pages/details_page.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final double width;
  final double height;

  const MovieCard({
    super.key,
    required this.movie,
    this.width = 144,
    this.height = 201,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPage(movie: movie),
          ),
        );
      },
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: AppSpacing.px12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.px10),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: AppSpacing.px6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.surface,
                child: const Center(
                  child: Icon(Icons.movie, size: 40, color: Colors.grey),
                ),
              ),
            ),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.85),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
            // Badge / Rating overlay at top left
            Positioned(
              top: AppSpacing.px8,
              left: AppSpacing.px8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.px6, vertical: AppSpacing.px3),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(AppSpacing.px4),
                  border: Border.all(color: Colors.white24, width: 0.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: AppColors.logoGold, size: 11),
                    AppSpacing.hGap3,
                    Text(
                      movie.rating.toStringAsFixed(1),
                      style: AppTextStyles.cardRating,
                    ),
                  ],
                ),
              ),
            ),
            // Title & Year at bottom
            Positioned(
              bottom: AppSpacing.px8,
              left: AppSpacing.px8,
              right: AppSpacing.px8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.cardTitle,
                  ),
                  AppSpacing.vGap2,
                  Text(
                    '${movie.year} • ${movie.certification}',
                    style: AppTextStyles.cardSubtitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
