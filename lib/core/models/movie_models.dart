import 'package:equatable/equatable.dart';
import 'enums.dart';

class GenreModel extends Equatable {
  final String id;
  final String name;

  const GenreModel({
    required this.id,
    required this.name,
  });

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  List<Object?> get props => [id, name];
}

class PersonModel extends Equatable {
  final String id;
  final String name;
  final String? profilePath;
  final String? biography;

  const PersonModel({
    required this.id,
    required this.name,
    this.profilePath,
    this.biography,
  });

  factory PersonModel.fromJson(Map<String, dynamic> json) {
    return PersonModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profilePath: json['profile_path'] as String?,
      biography: json['biography'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profile_path': profilePath,
      'biography': biography,
    };
  }

  @override
  List<Object?> get props => [id, name, profilePath, biography];
}

class MovieCastModel extends Equatable {
  final String personId;
  final String character;
  final int order;
  final PersonModel person;

  const MovieCastModel({
    required this.personId,
    required this.character,
    this.order = 0,
    required this.person,
  });

  factory MovieCastModel.fromJson(Map<String, dynamic> json) {
    return MovieCastModel(
      personId: json['person_id'] as String,
      character: json['character'] as String,
      order: json['order'] as int? ?? 0,
      person: PersonModel.fromJson(json['person'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'person_id': personId,
      'character': character,
      'order': order,
      'person': person.toJson(),
    };
  }

  @override
  List<Object?> get props => [personId, character, order, person];
}

class MovieCrewModel extends Equatable {
  final String personId;
  final String job;
  final String department;
  final PersonModel person;

  const MovieCrewModel({
    required this.personId,
    required this.job,
    required this.department,
    required this.person,
  });

  factory MovieCrewModel.fromJson(Map<String, dynamic> json) {
    return MovieCrewModel(
      personId: json['person_id'] as String,
      job: json['job'] as String,
      department: json['department'] as String,
      person: PersonModel.fromJson(json['person'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'person_id': personId,
      'job': job,
      'department': department,
      'person': person.toJson(),
    };
  }

  @override
  List<Object?> get props => [personId, job, department, person];
}

class MediaAssetModel extends Equatable {
  final String id;
  final AssetType assetType;
  final String? title;
  final String? language;
  final bool isPrimary;
  final String filePath;
  final String url;
  final DateTime createdAt;

  const MediaAssetModel({
    required this.id,
    required this.assetType,
    this.title,
    this.language,
    this.isPrimary = false,
    required this.filePath,
    required this.url,
    required this.createdAt,
  });

  factory MediaAssetModel.fromJson(Map<String, dynamic> json) {
    return MediaAssetModel(
      id: json['id'] as String,
      assetType: AssetTypeExtension.fromString(json['asset_type'] as String?),
      title: json['title'] as String?,
      language: json['language'] as String?,
      isPrimary: json['is_primary'] as bool? ?? false,
      filePath: json['file_path'] as String? ?? '',
      url: json['url'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'asset_type': assetType.toRawValue(),
      'title': title,
      'language': language,
      'is_primary': isPrimary,
      'file_path': filePath,
      'url': url,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        assetType,
        title,
        language,
        isPrimary,
        filePath,
        url,
        createdAt
      ];
}

/// Unified Movie model from OpenAPI (supports both Movie and MovieSummary)
class Movie extends Equatable {
  final String id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final String? releaseDate;
  final int? durationMinutes;
  final String? posterPath;
  final String? backdropPath;
  final double rating;
  final AgeRating ageRating;
  final bool isActive;
  final List<GenreModel> genresList;
  final List<MovieCastModel> castList;
  final List<MovieCrewModel> crewList;
  final List<MediaAssetModel> mediaAssets;

  // Custom mock/UI compatibility fields
  final String? _customDescription;
  final String? _customPosterUrl;
  final String? _customBackdropUrl;
  final int? _customYear;
  final String? _customDuration;
  final String? _customCertification;
  final String? _customLanguage;
  final List<String>? _customGenres;
  final List<String>? _customCast;
  final List<String>? _customCountries;
  final bool? _isOriginalFlag;
  final bool? _isPopularFlag;
  final bool? _isTopRatedFlag;
  final bool? _isNowPlayingFlag;
  final bool? _isTrendingFlag;

  const Movie({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.durationMinutes,
    this.posterPath,
    this.backdropPath,
    this.rating = 0.0,
    this.ageRating = AgeRating.unrated,
    this.isActive = true,
    this.genresList = const [],
    this.castList = const [],
    this.crewList = const [],
    this.mediaAssets = const [],
    String? description,
    String? posterUrl,
    String? backdropUrl,
    int? year,
    String? duration,
    String? certification,
    String? language,
    List<String>? genres,
    List<String>? cast,
    List<String>? countries,
    bool? isOriginal,
    bool? isPopular,
    bool? isTopRated,
    bool? isNowPlaying,
    bool? isTrending,
  })  : _customDescription = description,
        _customPosterUrl = posterUrl,
        _customBackdropUrl = backdropUrl,
        _customYear = year,
        _customDuration = duration,
        _customCertification = certification,
        _customLanguage = language,
        _customGenres = genres,
        _customCast = cast,
        _customCountries = countries,
        _isOriginalFlag = isOriginal,
        _isPopularFlag = isPopular,
        _isTopRatedFlag = isTopRated,
        _isNowPlayingFlag = isNowPlaying,
        _isTrendingFlag = isTrending;

  factory Movie.fromJson(Map<String, dynamic> json) {
    List<GenreModel> genres = [];
    if (json['genres'] != null && json['genres'] is List) {
      genres = (json['genres'] as List)
          .map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<MovieCastModel> cast = [];
    if (json['cast'] != null && json['cast'] is List) {
      cast = (json['cast'] as List)
          .map((e) => MovieCastModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<MovieCrewModel> crew = [];
    if (json['crew'] != null && json['crew'] is List) {
      crew = (json['crew'] as List)
          .map((e) => MovieCrewModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    List<MediaAssetModel> assets = [];
    if (json['media_assets'] != null && json['media_assets'] is List) {
      assets = (json['media_assets'] as List)
          .map((e) => MediaAssetModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return Movie(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Untitled',
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      releaseDate: json['release_date'] as String?,
      durationMinutes: json['duration_minutes'] as int?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ageRating: AgeRatingExtension.fromString(json['age_rating'] as String?),
      isActive: json['is_active'] as bool? ?? true,
      genresList: genres,
      castList: cast,
      crewList: crew,
      mediaAssets: assets,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'overview': overview,
      'release_date': releaseDate,
      'duration_minutes': durationMinutes,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'rating': rating,
      'age_rating': ageRating.displayName,
      'is_active': isActive,
      'genres': genresList.map((e) => e.toJson()).toList(),
      'cast': castList.map((e) => e.toJson()).toList(),
      'crew': crewList.map((e) => e.toJson()).toList(),
      'media_assets': mediaAssets.map((e) => e.toJson()).toList(),
    };
  }

  // Frontend compatibility getters for existing UI widgets
  String get description => _customDescription ?? overview ?? 'No description available.';
  String get posterUrl => _customPosterUrl ??
      ((posterPath != null && posterPath!.isNotEmpty)
          ? posterPath!
          : 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500');
  String get backdropUrl => _customBackdropUrl ??
      ((backdropPath != null && backdropPath!.isNotEmpty)
          ? backdropPath!
          : posterUrl);

  int get year {
    if (_customYear != null) return _customYear;
    if (releaseDate != null && releaseDate!.length >= 4) {
      final parsedYear = int.tryParse(releaseDate!.substring(0, 4));
      if (parsedYear != null) return parsedYear;
    }
    return 2026;
  }

  String get duration =>
      _customDuration ?? (durationMinutes != null ? '$durationMinutes mins' : '120 mins');
  String get certification => _customCertification ?? ageRating.displayName;
  String get language => _customLanguage ??
      (mediaAssets.isNotEmpty ? (mediaAssets.first.language ?? 'English') : 'English');
  List<String> get genres =>
      _customGenres ?? (genresList.isNotEmpty ? genresList.map((g) => g.name).toList() : const []);
  List<String> get cast => _customCast ??
      (castList.isNotEmpty
          ? castList.map((c) => '${c.person.name} (${c.character})').toList()
          : const []);
  List<String> get countries => _customCountries ?? const ['USA'];

  bool get isOriginal =>
      _isOriginalFlag ??
      genresList.any((g) => g.name.toLowerCase().contains('original')) ||
      rating >= 8.5;
  bool get isPopular => _isPopularFlag ?? rating >= 7.5;
  bool get isTopRated => _isTopRatedFlag ?? rating >= 8.0;
  bool get isNowPlaying => _isNowPlayingFlag ?? isActive;
  bool get isTrending => _isTrendingFlag ?? rating >= 8.2;

  @override
  List<Object?> get props => [
        id,
        title,
        originalTitle,
        overview,
        releaseDate,
        durationMinutes,
        posterPath,
        backdropPath,
        rating,
        ageRating,
        isActive,
        genresList,
        castList,
        crewList,
        mediaAssets,
        _customDescription,
        _customPosterUrl,
        _customBackdropUrl,
        _customYear,
        _customDuration,
        _customCertification,
        _customLanguage,
        _customGenres,
        _customCast,
        _customCountries,
        _isOriginalFlag,
        _isPopularFlag,
        _isTopRatedFlag,
        _isNowPlayingFlag,
        _isTrendingFlag,
      ];
}

class SectionDataResponse extends Equatable {
  final String sectionId;
  final List<Movie> items;
  final int page;
  final int size;
  final bool hasNext;

  const SectionDataResponse({
    required this.sectionId,
    required this.items,
    required this.page,
    required this.size,
    this.hasNext = false,
  });

  factory SectionDataResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List? ?? [])
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
    return SectionDataResponse(
      sectionId: json['section_id'] as String,
      items: list,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 10,
      hasNext: json['has_next'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [sectionId, items, page, size, hasNext];
}

class PaginatedMovies extends Equatable {
  final List<Movie> items;
  final int page;
  final int size;
  final bool hasNext;

  const PaginatedMovies({
    required this.items,
    required this.page,
    required this.size,
    this.hasNext = false,
  });

  factory PaginatedMovies.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List? ?? [])
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
    return PaginatedMovies(
      items: list,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 20,
      hasNext: json['has_next'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [items, page, size, hasNext];
}

class SearchResponse extends Equatable {
  final List<Movie> items;
  final int page;
  final int size;
  final bool hasNext;

  const SearchResponse({
    required this.items,
    required this.page,
    required this.size,
    this.hasNext = false,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List? ?? [])
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
    return SearchResponse(
      items: list,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 20,
      hasNext: json['has_next'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [items, page, size, hasNext];
}
