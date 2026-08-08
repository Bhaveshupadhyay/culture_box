import 'package:flutter/foundation.dart';
import '../../../../core/models/layout_models.dart';
import '../../../../core/models/movie_models.dart';
import '../api/movies_api_service.dart';

class MoviesRepository {
  final MoviesApiService moviesApiService;

  MoviesRepository({required this.moviesApiService});

  /// Formats relative video URLs (e.g. 'uploads/...') into full Cloudinary CDN Video URLs
  static String formatVideoUrl(String? url) {
    if (url == null || url.trim().isEmpty) return '';
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    // Append .mp4 if no extension is present so Cloudinary streams a valid MP4 container
    final hasExtension = trimmed.contains('.');
    final videoPath = hasExtension ? trimmed : '$trimmed.mp4';
    return 'https://res.cloudinary.com/dwyflu02w/video/upload/$videoPath';
  }

  /// Legacy & SDUI homepage layout
  Future<HomepageLayoutResponseModel> getHomepageLayout({String screenName = 'default'}) async {
    try {
      final rows = await moviesApiService.getHomeLayout();
      if (rows.isNotEmpty) {
        final sections = rows.map((r) => r.toLayoutSection()).toList();
        return HomepageLayoutResponseModel(sections: sections);
      }
    } catch (_) {}

    return const HomepageLayoutResponseModel(sections: []);
  }

  /// Get row items / section data
  Future<List<Movie>> getSectionData(String endpointOrSectionId) async {
    try {
      final intId = int.tryParse(endpointOrSectionId);
      if (intId != null) {
        final response = await moviesApiService.getContentRow(intId);
        return response.data.map((c) => c.toMovie()).toList();
      }
    } catch (_) {}

    return [];
  }

  /// Get movie details
  Future<Movie> getMovieDetails(String movieId) async {
    final intId = int.tryParse(movieId);
    if (intId != null) {
      final details = await moviesApiService.getContentDetails(intId);
      return details.toMovie();
    }
    throw Exception('Movie not found');
  }

  /// Get video or trailer URL directly from backend API
  Future<String> getMovieVideoUrl(String movieId, {bool isTrailer = false}) async {
    const String sampleStreamUrl =
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

    final intId = int.tryParse(movieId);
    if (intId == null) return sampleStreamUrl;

    try {
      final url = await moviesApiService.getVideoUrl(
        id: intId,
        contentId: intId,
        contentType: isTrailer ? 'trailer' : 'movie',
      );
      debugPrint('[MoviesRepository] getMovieVideoUrl parsed raw url: $url (isTrailer: $isTrailer)');
      if (url != null && url.isNotEmpty) {
        final formatted = formatVideoUrl(url);
        if (formatted.isNotEmpty) return formatted;
      }
    } catch (e) {
      debugPrint('[MoviesRepository] getMovieVideoUrl error: $e');
    }

    return sampleStreamUrl;
  }

  /// Search movies
  Future<List<Movie>> searchMovies({String? q, String? genre}) async {
    try {
      final query = q ?? (genre != null && genre != 'All' ? genre : '');
      if (query.isNotEmpty) {
        final response = await moviesApiService.searchContent(query: query);
        if (response.data.isNotEmpty) {
          var movies = response.data.map((c) => c.toMovie()).toList();
          if (genre != null && genre.isNotEmpty && genre != 'All') {
            movies = movies.where((m) => m.genres.contains(genre)).toList();
          }
          return movies;
        }
      }
    } catch (_) {}
    return [];
  }

  /// Recommended Content (GET /users/content/{id}/recommended)
  Future<List<Movie>> getRecommendedContent(int id) async {
    try {
      final response = await moviesApiService.getRecommendedContent(id);
      return response.data.map((c) => c.toMovie()).toList();
    } catch (_) {
      return [];
    }
  }

  /// Get Home Sliders (GET /users/home/sliders)
  Future<List<HomeSliderModel>> getHomeSliders() async {
    try {
      return await moviesApiService.getHomeSliders();
    } catch (_) {
      return [];
    }
  }

  /// Get User Plans
  Future<List<PlanModel>> getUserPlans() async {
    try {
      return await moviesApiService.getUserPlans();
    } catch (_) {
      return const [
        PlanModel(id: 1, planName: 'basic', monthlyPrice: '6.99', maxScreens: 3),
        PlanModel(id: 2, planName: 'premium', monthlyPrice: '69.99', maxScreens: 8),
      ];
    }
  }
}
