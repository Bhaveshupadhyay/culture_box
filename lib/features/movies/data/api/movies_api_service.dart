import 'package:flutter/foundation.dart';
import '../../../../core/models/layout_models.dart';
import '../../../../core/models/movie_models.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

class MoviesApiService {
  final ApiClient apiClient;

  MoviesApiService(this.apiClient);

  /// Get Homepage Layout Rows (GET /users/home/layout)
  Future<List<HomeLayoutRowModel>> getHomeLayout() async {
    final response = await apiClient.get(ApiEndpoints.homeLayout);
    final json = response.data as Map<String, dynamic>;
    final list = (json['data'] as List? ?? [])
        .map((e) => HomeLayoutRowModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  /// Get Homepage Sliders (GET /users/home/sliders)
  Future<List<HomeSliderModel>> getHomeSliders() async {
    final response = await apiClient.get(ApiEndpoints.homeSliders);
    final json = response.data as Map<String, dynamic>;
    final list = (json['data'] as List? ?? [])
        .map((e) => HomeSliderModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  /// Get Home Page Row Content (GET /users/content/row/{id})
  Future<PaginatedContentResponse> getContentRow(
    int rowId, {
    int? limit,
    String? cursor,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (cursor != null) queryParams['cursor'] = cursor;

    final response = await apiClient.get(
      ApiEndpoints.contentRow(rowId),
      queryParameters: queryParams,
    );
    return PaginatedContentResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get Content Details by ID (GET /users/content/{id})
  Future<ContentDetailsModel> getContentDetails(
    int id, {
    int? limit,
    String? cursor,
    int? season,
  }) async {
    final queryParams = <String, dynamic>{};
    if (limit != null) queryParams['limit'] = limit;
    if (cursor != null) queryParams['cursor'] = cursor;
    if (season != null) queryParams['season'] = season;

    final response = await apiClient.get(
      ApiEndpoints.contentDetails(id),
      queryParameters: queryParams,
    );
    final json = response.data as Map<String, dynamic>;
    final dataMap = json['data'] != null && json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;
    return ContentDetailsModel.fromJson(dataMap);
  }

  /// Get Media Asset / Video URL (GET /users/content/video-url)
  Future<String?> getVideoUrl({
    required int id,
    required int contentId,
    required String contentType,
  }) async {
    try {
      // Map contentType to OpenAPI enum spec ['movie', 'web_series']
      final resolvedType = (contentType == 'web_series' || contentType == 'series')
          ? 'web_series'
          : 'movie';

      final response = await apiClient.get(
        ApiEndpoints.contentVideoUrl,
        queryParameters: {
          'id': id.toString(),
          'content_id': contentId.toString(),
          'content_type': resolvedType,
        },
      );
      debugPrint('[MoviesApiService] getVideoUrl response: ${response.data}');
      final json = response.data as Map<String, dynamic>;
      if (json.containsKey('data') && json['data'] != null) {
        final data = json['data'];
        if (data is String && data.isNotEmpty) return data;
        if (data is Map<String, dynamic>) {
          if (data.containsKey('vimeo_data') && data['vimeo_data'] is Map) {
            final vimeo = data['vimeo_data'] as Map<String, dynamic>;
            if (vimeo.containsKey('id') && vimeo['id'] != null) {
              final vimeoId = vimeo['id'].toString();
              return 'https://player.vimeo.com/video/$vimeoId';
            }
          }
          return data['video_url'] as String? ??
              data['url'] as String? ??
              data['stream_url'] as String? ??
              data['videoUrl'] as String?;
        }
      }
      if (json.containsKey('video_url')) return json['video_url'] as String?;
      if (json.containsKey('url')) return json['url'] as String?;
      if (json.containsKey('stream_url')) return json['stream_url'] as String?;
    } catch (e) {
      debugPrint('[MoviesApiService] getVideoUrl error: $e');
    }
    return null;
  }

  /// Get Recommended Content (GET /users/content/{id}/recommended)
  Future<PaginatedContentResponse> getRecommendedContent(int id) async {
    final response = await apiClient.get(ApiEndpoints.recommendedContent(id));
    return PaginatedContentResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Search Content (GET /users/search)
  Future<PaginatedContentResponse> searchContent({
    required String query,
    int? limit,
    String? cursor,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.search,
      queryParameters: {
        'q': query,
        ...?limit == null ? null : {'limit': limit},
        ...?cursor == null ? null : {'cursor': cursor},
      },
    );
    return PaginatedContentResponse.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get Active Plans (GET /users/plans)
  Future<List<PlanModel>> getUserPlans() async {
    final response = await apiClient.get(ApiEndpoints.userPlans);
    final json = response.data as Map<String, dynamic>;
    if (json.containsKey('data')) {
      final data = json['data'];
      if (data is List) {
        return data.map((e) => PlanModel.fromJson(e as Map<String, dynamic>)).toList();
      } else if (data is Map && data.containsKey('plans')) {
        return (data['plans'] as List)
            .map((e) => PlanModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }
    return [];
  }
}
