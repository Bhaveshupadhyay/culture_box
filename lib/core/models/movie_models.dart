import 'package:equatable/equatable.dart';
import 'enums.dart';

class Movie extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? posterPath;
  final String? backdropPath;
  final String? thumbnailUrl;
  final String? backdropUrl;
  final String? posterUrl;
  final double voteAverage;
  final int voteCount;
  final int? year;
  final DateTime? releaseDate;
  final String? duration;
  final String? certification;
  final String? language;
  final List<String> genres;
  final List<dynamic> cast;
  final List<String> countries;
  final String contentType;
  final String? rating;
  final int? sortOrder;
  final bool isOriginal;
  final bool isTrending;
  final bool isPopular;
  final bool isTopRated;
  final bool isNowPlaying;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    this.posterPath,
    this.backdropPath,
    this.thumbnailUrl,
    this.backdropUrl,
    this.posterUrl,
    this.voteAverage = 0.0,
    this.voteCount = 0,
    this.year,
    this.releaseDate,
    this.duration,
    this.certification,
    this.language,
    this.genres = const [],
    this.cast = const [],
    this.countries = const [],
    this.contentType = 'movie',
    this.rating,
    this.sortOrder,
    this.isOriginal = false,
    this.isTrending = false,
    this.isPopular = false,
    this.isTopRated = false,
    this.isNowPlaying = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final String idStr = json['id']?.toString() ?? '';
    final String ratingStr = json['rating']?.toString() ?? json['vote_average']?.toString() ?? '5.0';
    final double ratingVal = (json['vote_average'] as num?)?.toDouble() ?? double.tryParse(ratingStr) ?? 0.0;

    DateTime? parsedDate;
    int? parsedYear = json['year'] as int?;
    if (json['release_date'] != null) {
      if (json['release_date'] is int) {
        parsedYear ??= json['release_date'] as int;
        parsedDate = DateTime(json['release_date'] as int);
      } else if (json['release_date'] is String) {
        parsedDate = DateTime.tryParse(json['release_date'] as String);
        if (parsedDate != null) parsedYear ??= parsedDate.year;
      }
    }

    return Movie(
      id: idStr,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      backdropUrl: json['backdrop_url'] as String?,
      posterUrl: json['posterUrl'] as String? ?? json['poster_url'] as String?,
      voteAverage: ratingVal,
      voteCount: json['vote_count'] as int? ?? 0,
      year: parsedYear,
      releaseDate: parsedDate,
      duration: json['duration'] as String?,
      certification: json['certification'] as String?,
      language: json['language'] as String?,
      genres: (json['genres'] as List? ?? []).map((e) => e.toString()).toList(),
      cast: json['cast'] as List? ?? [],
      countries: (json['countries'] as List? ?? []).map((e) => e.toString()).toList(),
      contentType: json['content_type'] as String? ?? 'movie',
      rating: ratingStr,
      sortOrder: json['sort_order'] as int?,
      isOriginal: json['is_original'] as bool? ?? false,
      isTrending: json['is_trending'] as bool? ?? false,
      isPopular: json['is_popular'] as bool? ?? false,
      isTopRated: json['is_top_rated'] as bool? ?? false,
      isNowPlaying: json['is_now_playing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'thumbnail_url': thumbnailUrl,
      'backdrop_url': backdropUrl,
      'poster_url': posterUrl,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'year': year,
      'release_date': releaseDate?.toIso8601String(),
      'duration': duration,
      'certification': certification,
      'language': language,
      'genres': genres,
      'cast': cast,
      'countries': countries,
      'content_type': contentType,
      'rating': rating,
      'sort_order': sortOrder,
    };
  }

  String get effectivePoster => posterUrl ?? thumbnailUrl ?? posterPath ?? backdropUrl ?? backdropPath ?? '';
  String get effectiveBackdrop => backdropUrl ?? backdropPath ?? thumbnailUrl ?? posterPath ?? posterUrl ?? '';

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        posterPath,
        backdropPath,
        thumbnailUrl,
        backdropUrl,
        posterUrl,
        voteAverage,
        voteCount,
        year,
        releaseDate,
        duration,
        certification,
        language,
        genres,
        cast,
        countries,
        contentType,
        rating,
        sortOrder,
      ];
}

class ContentItemModel extends Equatable {
  final int id;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String? backdropUrl;
  final String contentType;
  final String? rating;
  final int? sortOrder;
  final int? releaseDate;

  const ContentItemModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnailUrl,
    this.backdropUrl,
    required this.contentType,
    this.rating,
    this.sortOrder,
    this.releaseDate,
  });

  factory ContentItemModel.fromJson(Map<String, dynamic> json) {
    return ContentItemModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      backdropUrl: json['backdrop_url'] as String?,
      contentType: json['content_type'] as String? ?? 'movie',
      rating: json['rating'] as String?,
      sortOrder: json['sort_order'] as int?,
      releaseDate: json['release_date'] as int?,
    );
  }

  Movie toMovie() {
    return Movie(
      id: id.toString(),
      title: title,
      description: description ?? '',
      thumbnailUrl: thumbnailUrl,
      backdropUrl: backdropUrl,
      contentType: contentType,
      rating: rating,
      voteAverage: double.tryParse(rating ?? '5.0') ?? 5.0,
      year: releaseDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'backdrop_url': backdropUrl,
      'content_type': contentType,
      'rating': rating,
      'sort_order': sortOrder,
      'release_date': releaseDate,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnailUrl,
        backdropUrl,
        contentType,
        rating,
        sortOrder,
        releaseDate,
      ];
}

class ContentDetailsModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final String? backdropUrl;
  final String contentType;
  final String? rating;
  final int? releaseDate;
  final List<dynamic> seasons;
  final List<dynamic> episodes;
  final List<dynamic> categories;

  const ContentDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    this.backdropUrl,
    required this.contentType,
    this.rating,
    this.releaseDate,
    this.seasons = const [],
    this.episodes = const [],
    this.categories = const [],
  });

  factory ContentDetailsModel.fromJson(Map<String, dynamic> json) {
    return ContentDetailsModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      backdropUrl: json['backdrop_url'] as String?,
      contentType: json['content_type'] as String? ?? 'movie',
      rating: json['rating'] as String?,
      releaseDate: json['release_date'] as int?,
      seasons: json['seasons'] as List? ?? [],
      episodes: json['episodes'] as List? ?? [],
      categories: json['categories'] as List? ?? [],
    );
  }

  Movie toMovie() {
    return Movie(
      id: id.toString(),
      title: title,
      description: description,
      backdropUrl: backdropUrl,
      contentType: contentType,
      rating: rating,
      voteAverage: double.tryParse(rating ?? '5.0') ?? 5.0,
      year: releaseDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'backdrop_url': backdropUrl,
      'content_type': contentType,
      'rating': rating,
      'release_date': releaseDate,
      'seasons': seasons,
      'episodes': episodes,
      'categories': categories,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        backdropUrl,
        contentType,
        rating,
        releaseDate,
        seasons,
        episodes,
        categories,
      ];
}

class MediaAssetModel extends Equatable {
  final String id;
  final String url;
  final AssetType assetType;

  const MediaAssetModel({
    required this.id,
    required this.url,
    required this.assetType,
  });

  factory MediaAssetModel.fromJson(Map<String, dynamic> json) {
    return MediaAssetModel(
      id: json['id']?.toString() ?? '',
      url: json['url'] as String? ?? '',
      assetType: AssetTypeExtension.fromString(json['asset_type'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'asset_type': assetType.name,
    };
  }

  @override
  List<Object?> get props => [id, url, assetType];
}

class SectionDataResponse extends Equatable {
  final List<Movie> items;

  const SectionDataResponse({required this.items});

  factory SectionDataResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List? ?? json['data'] as List? ?? [])
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
    return SectionDataResponse(items: list);
  }

  @override
  List<Object?> get props => [items];
}

class SearchResponse extends Equatable {
  final List<Movie> items;

  const SearchResponse({required this.items});

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List? ?? json['data'] as List? ?? [])
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
    return SearchResponse(items: list);
  }

  @override
  List<Object?> get props => [items];
}

class PaginatedMovies extends Equatable {
  final List<Movie> items;
  final int page;
  final int totalPages;
  final int totalResults;

  const PaginatedMovies({
    required this.items,
    this.page = 1,
    this.totalPages = 1,
    this.totalResults = 0,
  });

  factory PaginatedMovies.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List? ?? json['data'] as List? ?? [])
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedMovies(
      items: list,
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      totalResults: json['total_results'] as int? ?? list.length,
    );
  }

  @override
  List<Object?> get props => [items, page, totalPages, totalResults];
}

class PaginatedContentResponse extends Equatable {
  final bool isSuccess;
  final List<ContentItemModel> data;
  final String? nextCursor;
  final bool hasMore;

  const PaginatedContentResponse({
    required this.isSuccess,
    required this.data,
    this.nextCursor,
    required this.hasMore,
  });

  factory PaginatedContentResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List? ?? [])
        .map((e) => ContentItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedContentResponse(
      isSuccess: json['isSuccess'] as bool? ?? true,
      data: list,
      nextCursor: json['nextCursor'] as String?,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [isSuccess, data, nextCursor, hasMore];
}

class PlanModel extends Equatable {
  final int id;
  final String planName;
  final String monthlyPrice;
  final int maxScreens;

  const PlanModel({
    required this.id,
    required this.planName,
    required this.monthlyPrice,
    required this.maxScreens,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as int? ?? 0,
      planName: json['plan_name'] as String? ?? '',
      monthlyPrice: json['monthly_price'] as String? ?? '0.0',
      maxScreens: json['max_screens'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plan_name': planName,
      'monthly_price': monthlyPrice,
      'max_screens': maxScreens,
    };
  }

  @override
  List<Object?> get props => [id, planName, monthlyPrice, maxScreens];
}
