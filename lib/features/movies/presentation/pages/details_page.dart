import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/service_locator.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../data/models/movie.dart';
import '../bloc/movie_details_cubit.dart';
import '../widgets/movie_card.dart';
import 'video_player_page.dart';

class DetailsPage extends StatefulWidget {
  final String movieId;

  const DetailsPage({super.key, required this.movieId});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late final MovieDetailsCubit _detailsCubit;

  @override
  void initState() {
    super.initState();
    _detailsCubit = ServiceLocator.instance.createMovieDetailsCubit();
    _detailsCubit.fetchMovieDetails(widget.movieId);
  }

  @override
  void dispose() {
    _detailsCubit.close();
    super.dispose();
  }

  void _onWatchNowPressed(Movie movie, String videoUrl) {
    final isAuthenticated = ServiceLocator.instance.authRepository.isAuthenticated;
    if (!isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to watch full movies.'),
          backgroundColor: AppColors.logoRedOrange,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(
            title: movie.title,
            videoUrl: videoUrl,
            isTrailer: false,
          ),
        ),
      );
    }
  }

  void _onPlayTrailerPressed(Movie movie, String trailerUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(
          title: '${movie.title} (Trailer)',
          videoUrl: trailerUrl,
          isTrailer: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _detailsCubit,
      child: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
          builder: (context, state) {
            if (state is MovieDetailsLoading || state is MovieDetailsInitial) {
              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: const DetailsPageShimmer(),
              );
            }

            if (state is MovieDetailsError) {
              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                body: Center(
                  child: Padding(
                    padding: AppSpacing.all24,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                        AppSpacing.vGap16,
                        Text(
                          'Failed to Load Details',
                          style: AppTextStyles.emptyStateTitle,
                        ),
                        AppSpacing.vGap8,
                        Text(
                          state.message,
                          style: AppTextStyles.emptyStateSubtitle,
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.vGap24,
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.logoRedOrange,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _detailsCubit.fetchMovieDetails(widget.movieId),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is MovieDetailsLoaded) {
              final movie = state.movie;
              final relatedMovies = state.relatedMovies;
              final trailerUrl = state.trailerUrl;
              final videoUrl = state.videoUrl;

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
                          child: AppNetworkImage(
                            imageUrl: movie.backdropUrl,
                            fit: BoxFit.cover,
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
                                    onPressed: () => _onWatchNowPressed(movie, videoUrl),
                                    icon: const Icon(Icons.play_arrow, color: Colors.black),
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
                                    onPressed: () => _onPlayTrailerPressed(movie, trailerUrl),
                                    icon: const Icon(Icons.movie_outlined, color: Colors.white),
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
                          Text(
                            movie.description,
                            style: AppTextStyles.bodyText,
                          ),
                          AppSpacing.vGap16,
                          if (movie.genres.isNotEmpty) ...[
                            _buildDetailRow('Genres:', movie.genres.join(', ')),
                            AppSpacing.vGap8,
                          ],
                          if (movie.cast.isNotEmpty) ...[
                            _buildDetailRow('Cast:', movie.cast.join(', '), isAccent: true),
                            AppSpacing.vGap8,
                          ],
                          _buildDetailRow('Country:', movie.countries.join(', ')),
                          AppSpacing.vGap32,
                          if (relatedMovies.isNotEmpty) ...[
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
                        ],
                      ),
                    ),
                  ],
                ),
              ));
            }

            return const Scaffold(
              backgroundColor: AppColors.background,
            );
          },
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
