import '../../../../core/models/enums.dart';
import '../../../../core/models/layout_models.dart';
import '../../../../core/models/movie_models.dart';
import '../../../../core/network/api_endpoints.dart';
import '../api/movies_api_service.dart';
import '../sources/mock_movies.dart';

class MoviesRepository {
  final MoviesApiService moviesApiService;

  MoviesRepository({required this.moviesApiService});

  Future<HomepageLayoutResponseModel> getHomepageLayout({String screenName = 'default'}) async {
    try {
      final layout = await moviesApiService.getHomepageLayout(screenName: screenName);
      if (layout.sections.isNotEmpty) {
        return layout;
      }
    } catch (_) {}

    // Fallback SDUI layout if API layout endpoint fails
    return const HomepageLayoutResponseModel(
      sections: [
        LayoutSectionModel(
          sectionId: 'trending_hero',
          sectionName: 'Trending Now',
          widgetType: WidgetType.heroCarousel,
          scrollType: ScrollType.horizontal,
          dataEndpoint: '/api/v1/homepage/sections/trending_hero',
        ),
        LayoutSectionModel(
          sectionId: 'new_releases',
          sectionName: 'Fresh Out of the Box',
          widgetType: WidgetType.horizontalList,
          scrollType: ScrollType.horizontal,
          dataEndpoint: '/api/v1/homepage/sections/new_releases',
        ),
        LayoutSectionModel(
          sectionId: 'top_rated',
          sectionName: 'All-Time Greats',
          widgetType: WidgetType.grid,
          scrollType: ScrollType.vertical,
          dataEndpoint: '/api/v1/homepage/sections/top_rated',
        ),
      ],
    );
  }

  Future<List<Movie>> getSectionData(String endpointOrSectionId) async {
    try {
      final response = await moviesApiService.getSectionData(endpointOrSectionId);
      if (response.items.isNotEmpty) {
        return response.items;
      }
    } catch (_) {}

    // Robust fallback if backend endpoint returns 500 error or empty items
    final lowerId = endpointOrSectionId.toLowerCase();
    if (lowerId.contains('hero') || lowerId.contains('trending')) {
      return mockMovies.where((m) => m.isOriginal || m.isTrending).toList();
    } else if (lowerId.contains('new') || lowerId.contains('release') || lowerId.contains('originals')) {
      return mockMovies.where((m) => m.isOriginal || m.isNowPlaying).toList();
    } else if (lowerId.contains('top') || lowerId.contains('rated')) {
      return mockMovies.where((m) => m.isTopRated || m.isPopular).toList();
    }
    return mockMovies;
  }

  Future<Movie> getMovieDetails(String movieId) async {
    try {
      return await moviesApiService.getMovieDetails(movieId);
    } catch (_) {
      final mock = mockMovies.firstWhere(
        (m) => m.id == movieId,
        orElse: () => mockMovies.first,
      );
      return mock;
    }
  }

  Future<String> getMovieVideoUrl(String movieId, {bool isTrailer = false}) async {
    const String defaultVideoUrl =
        'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
    try {
      final assets = await moviesApiService.getMovieAssets(movieId);
      if (assets.isNotEmpty) {
        final targetType = isTrailer ? AssetType.trailer : AssetType.video;
        final matchingAsset = assets.firstWhere(
          (a) => a.assetType == targetType,
          orElse: () => assets.first,
        );
        if (matchingAsset.url.isNotEmpty) {
          String url = matchingAsset.url;
          if (!url.startsWith('http')) {
            url = '${ApiEndpoints.baseUrl}$url';
          }
          return url;
        }
      }
    } catch (_) {}

    return defaultVideoUrl;
  }

  Future<List<Movie>> searchMovies({String? q, String? genre}) async {
    try {
      final response = await moviesApiService.searchMovies(q: q, genre: genre);
      if (response.items.isNotEmpty) {
        return response.items;
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
}
