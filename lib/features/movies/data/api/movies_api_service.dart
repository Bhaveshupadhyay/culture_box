import '../../../../core/models/layout_models.dart';
import '../../../../core/models/movie_models.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class MoviesApiService {
  final ApiClient apiClient;

  MoviesApiService(this.apiClient);

  Future<HomepageLayoutResponseModel> getHomepageLayout({String screenName = 'default'}) async {
    final response = await apiClient.get(
      ApiEndpoints.homepageLayout,
      queryParameters: {'screen_name': screenName},
    );
    return HomepageLayoutResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<SectionDataResponse> getSectionData(String endpointOrSectionId, {int page = 1, int size = 10}) async {
    String path = endpointOrSectionId;
    if (!path.startsWith('/')) {
      path = '${ApiEndpoints.homepageSection}/$path';
    }

    final response = await apiClient.get(
      path,
      queryParameters: {
        'page': page,
        'size': size,
      },
    );
    return SectionDataResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<Movie> getMovieDetails(String movieId) async {
    final response = await apiClient.get(ApiEndpoints.movieDetails(movieId));
    return Movie.fromJson(response.data as Map<String, dynamic>);
  }

  Future<List<MediaAssetModel>> getMovieAssets(String movieId) async {
    final response = await apiClient.get('/api/v1/movies/$movieId/assets');
    if (response.data is List) {
      return (response.data as List)
          .map((e) => MediaAssetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  Future<SearchResponse> searchMovies({
    String? q,
    String? genre,
    int page = 1,
    int size = 20,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'size': size,
    };
    if (q != null && q.isNotEmpty) queryParams['q'] = q;
    if (genre != null && genre.isNotEmpty && genre != 'All') queryParams['genre'] = genre;

    final response = await apiClient.get(
      ApiEndpoints.search,
      queryParameters: queryParams,
    );
    return SearchResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<PaginatedMovies> getMovies({
    int page = 1,
    int size = 20,
    String? search,
    String? genreId,
    int? year,
    String sortBy = 'release_date',
    String sortOrder = 'desc',
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'size': size,
      'sort_by': sortBy,
      'sort_order': sortOrder,
    };
    if (search != null) queryParams['search'] = search;
    if (genreId != null) queryParams['genre_id'] = genreId;
    if (year != null) queryParams['year'] = year;

    final response = await apiClient.get(
      ApiEndpoints.movies,
      queryParameters: queryParams,
    );
    return PaginatedMovies.fromJson(response.data as Map<String, dynamic>);
  }
}
