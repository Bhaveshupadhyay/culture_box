import '../../../../core/models/enums.dart';
import '../../../../core/models/layout_models.dart';
import '../../../../core/models/movie_models.dart';
import '../api/movies_api_service.dart';
import '../sources/mock_movies.dart';

class MoviesRepository {
  final MoviesApiService moviesApiService;

  MoviesRepository({required this.moviesApiService});

  /// Legacy & SDUI homepage layout
  Future<HomepageLayoutResponseModel> getHomepageLayout({String screenName = 'default'}) async {
    try {
      final rows = await moviesApiService.getHomeLayout();
      if (rows.isNotEmpty) {
        final sections = rows.map((r) => r.toLayoutSection()).toList();
        return HomepageLayoutResponseModel(sections: sections);
      }
    } catch (_) {}

    return const HomepageLayoutResponseModel(
      sections: [
        LayoutSectionModel(
          sectionId: 'trending_hero',
          sectionName: 'Trending Now',
          widgetType: WidgetType.heroCarousel,
          scrollType: ScrollType.horizontal,
          dataEndpoint: '6',
        ),
        LayoutSectionModel(
          sectionId: 'new_releases',
          sectionName: 'Popular Movies',
          widgetType: WidgetType.horizontalList,
          scrollType: ScrollType.horizontal,
          dataEndpoint: '8',
        ),
        LayoutSectionModel(
          sectionId: 'top_rated',
          sectionName: 'Trending',
          widgetType: WidgetType.horizontalList,
          scrollType: ScrollType.horizontal,
          dataEndpoint: '7',
        ),
      ],
    );
  }

  /// Get row items / section data
  Future<List<Movie>> getSectionData(String endpointOrSectionId) async {
    try {
      final intId = int.tryParse(endpointOrSectionId);
      if (intId != null) {
        final response = await moviesApiService.getContentRow(intId);
        if (response.data.isNotEmpty) {
          return response.data.map((c) => c.toMovie()).toList();
        }
      }
    } catch (_) {}

    final lowerId = endpointOrSectionId.toLowerCase();
    if (lowerId.contains('hero') || lowerId.contains('trending') || lowerId == '6') {
      return mockMovies.where((m) => m.isOriginal || m.isTrending).toList();
    } else if (lowerId.contains('new') || lowerId.contains('popular') || lowerId == '8') {
      return mockMovies.where((m) => m.isOriginal || m.isNowPlaying).toList();
    } else if (lowerId.contains('top') || lowerId == '7') {
      return mockMovies.where((m) => m.isTopRated || m.isPopular).toList();
    }
    return mockMovies;
  }

  /// Get movie details
  Future<Movie> getMovieDetails(String movieId) async {
    try {
      final intId = int.tryParse(movieId);
      if (intId != null) {
        final details = await moviesApiService.getContentDetails(intId);
        return details.toMovie();
      }
    } catch (_) {}

    return mockMovies.firstWhere(
      (m) => m.id == movieId,
      orElse: () => mockMovies.first,
    );
  }

  /// Get video or trailer URL
  Future<String> getMovieVideoUrl(String movieId, {bool isTrailer = false}) async {
    const String defaultVideoUrl =
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    try {
      final intId = int.tryParse(movieId) ?? 9;
      final url = await moviesApiService.getVideoUrl(
        id: intId,
        contentId: intId,
        contentType: 'movie',
      );
      if (url != null && url.isNotEmpty) {
        return url;
      }
    } catch (_) {}
    return defaultVideoUrl;
  }

  /// Search movies
  Future<List<Movie>> searchMovies({String? q, String? genre}) async {
    try {
      final query = q ?? genre ?? '';
      if (query.isNotEmpty) {
        final response = await moviesApiService.searchContent(query: query);
        if (response.data.isNotEmpty) {
          return response.data.map((c) => c.toMovie()).toList();
        }
      }
    } catch (_) {}

    final query = q?.toLowerCase().trim() ?? '';
    return mockMovies.where((movie) {
      final matchesQuery = query.isEmpty ||
          movie.title.toLowerCase().contains(query) ||
          movie.description.toLowerCase().contains(query);
      final matchesGenre = genre == null || genre == 'All' || movie.genres.contains(genre);
      return matchesQuery && matchesGenre;
    }).toList();
  }

  /// Get Home Sliders
  Future<List<HomeSliderModel>> getHomeSliders() async {
    try {
      final sliders = await moviesApiService.getHomeSliders();
      if (sliders.isNotEmpty) return sliders;
    } catch (_) {}
    return [];
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
