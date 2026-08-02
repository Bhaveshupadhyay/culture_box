import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../data/mock_movies.dart';
import '../theme/app_theme.dart';
import '../widgets/movie_card.dart';

class DetailsScreen extends StatelessWidget {
  final Movie movie;

  const DetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final relatedMovies =
        mockMovies.where((m) => m.id != movie.id).take(4).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Backdrop Header
            Stack(
              children: [
                SizedBox(
                  height: AppSpacing.px380,
                  width: double.infinity,
                  child: Image.network(
                    movie.backdropUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: AppColors.surface,
                      child:
                          const Icon(Icons.movie, size: 60, color: Colors.grey),
                    ),
                  ),
                ),
                // Gradient Overlay
                Container(
                  height: AppSpacing.px380,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.85),
                        Colors.black,
                      ],
                      stops: const [0.0, 0.3, 0.8, 1.0],
                    ),
                  ),
                ),
                // Top Action Bar
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.px16, vertical: AppSpacing.px8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.detailsTitle,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Movie Info Details
            Padding(
              padding: AppSpacing.h16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta Info Pills (Year, Rating, Age, Lang, Duration)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMetaBadge('${movie.year}'),
                        _buildRatingBadge(movie.rating),
                        _buildMetaBadge(movie.certification),
                        _buildMetaBadge(movie.language),
                        _buildMetaBadge(movie.duration),
                      ],
                    ),
                  ),
                  AppSpacing.vGap16,
                  // Action Buttons (Watch Now & Play Trailer)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: AppSpacing.px44,
                          decoration: BoxDecoration(
                            gradient: AppColors.buttonGradient,
                            borderRadius: BorderRadius.circular(AppSpacing.px8),
                          ),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.px8),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Playing ${movie.title}...'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.black),
                            label: Text(
                              'WATCH NOW',
                              style: AppTextStyles.buttonTextDark,
                            ),
                          ),
                        ),
                      ),
                      AppSpacing.hGap12,
                      Expanded(
                        child: SizedBox(
                          height: AppSpacing.px44,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.buttonDark,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSpacing.px8),
                                side: const BorderSide(color: Colors.white24),
                              ),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Trailer player opening...'),
                                ),
                              );
                            },
                            icon: const Icon(Icons.movie_outlined,
                                color: Colors.white),
                            label: Text(
                              'PLAY TRAILER',
                              style: AppTextStyles.buttonText,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vGap20,
                  // Plot Summary
                  Text(
                    movie.description,
                    style: AppTextStyles.bodyText,
                  ),
                  AppSpacing.vGap16,
                  // Genres
                  _buildDetailRow('Genres:', movie.genres.join(', ')),
                  AppSpacing.vGap8,
                  // Cast
                  _buildDetailRow('Cast:', movie.cast.join(', '),
                      isAccent: true),
                  AppSpacing.vGap8,
                  // Country
                  _buildDetailRow('Country:', movie.countries.join(', ')),
                  AppSpacing.vGap32,
                  // More Like This Section
                  Text(
                    'More Like This',
                    style: AppTextStyles.sectionTitle,
                  ),
                  AppSpacing.vGap12,
                  SizedBox(
                    height: AppSpacing.px200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: relatedMovies.length,
                      itemBuilder: (context, index) {
                        return MovieCard(movie: relatedMovies[index]);
                      },
                    ),
                  ),
                  AppSpacing.vGap30,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaBadge(String text) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.px8),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px10, vertical: AppSpacing.px5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.px6),
        border: Border.all(color: Colors.white12),
      ),
      child: Text(
        text,
        style: AppTextStyles.badgeMeta,
      ),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.px8),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.px10, vertical: AppSpacing.px5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.px6),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.amber, size: 14),
          AppSpacing.hGap4,
          Text(
            rating.toStringAsFixed(1),
            style: AppTextStyles.badgeRating,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAccent = false}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label ',
            style: AppTextStyles.detailLabel,
          ),
          TextSpan(
            text: value,
            style: isAccent ? AppTextStyles.detailValueAccent : AppTextStyles.detailValue,
          ),
        ],
      ),
    );
  }
}
