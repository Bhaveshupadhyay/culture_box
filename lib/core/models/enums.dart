enum WidgetType {
  heroCarousel,
  horizontalList,
  verticalList,
  grid,
  unknown,
}

extension WidgetTypeExtension on WidgetType {
  static WidgetType fromString(String? value) {
    if (value == null) return WidgetType.unknown;
    final normalized = value.toLowerCase().replaceAll('-', '_').replaceAll(' ', '_');
    switch (normalized) {
      case 'hero_slider':
      case 'hero_carousel':
      case 'herocarousel':
      case 'heroslider':
      case 'hero':
        return WidgetType.heroCarousel;
      case 'standard_carousel':
      case 'horizontal_list':
      case 'horizontallist':
      case 'horizontal':
      case 'carousel':
        return WidgetType.horizontalList;
      case 'vertical_list':
      case 'verticallist':
      case 'vertical':
      case 'list':
        return WidgetType.verticalList;
      case 'grid_view':
      case 'gridview':
      case 'grid':
        return WidgetType.grid;
      default:
        return WidgetType.unknown;
    }
  }

  String toRawValue() {
    switch (this) {
      case WidgetType.heroCarousel:
        return 'hero_carousel';
      case WidgetType.horizontalList:
        return 'horizontal_list';
      case WidgetType.verticalList:
        return 'vertical_list';
      case WidgetType.grid:
        return 'grid';
      case WidgetType.unknown:
        return 'unknown';
    }
  }
}

enum ScrollType {
  horizontal,
  vertical,
  none,
  unknown,
}

extension ScrollTypeExtension on ScrollType {
  static ScrollType fromString(String? value) {
    if (value == null) return ScrollType.unknown;
    final normalized = value.toLowerCase();
    switch (normalized) {
      case 'horizontal':
        return ScrollType.horizontal;
      case 'vertical':
        return ScrollType.vertical;
      case 'none':
        return ScrollType.none;
      default:
        return ScrollType.unknown;
    }
  }

  String toRawValue() => name;
}

enum AssetType {
  video,
  trailer,
  thumbnail,
  poster,
  banner,
  subtitle,
  unknown,
}

extension AssetTypeExtension on AssetType {
  static AssetType fromString(String? value) {
    if (value == null) return AssetType.unknown;
    switch (value.toLowerCase()) {
      case 'video':
        return AssetType.video;
      case 'trailer':
        return AssetType.trailer;
      case 'thumbnail':
        return AssetType.thumbnail;
      case 'poster':
        return AssetType.poster;
      case 'banner':
        return AssetType.banner;
      case 'subtitle':
        return AssetType.subtitle;
      default:
        return AssetType.unknown;
    }
  }

  String toRawValue() => name;
}

enum AgeRating {
  g,
  pg,
  pg13,
  r,
  nc17,
  tvMa,
  unrated,
  unknown,
}

extension AgeRatingExtension on AgeRating {
  static AgeRating fromString(String? value) {
    if (value == null) return AgeRating.unknown;
    switch (value.toUpperCase().replaceAll('-', '').replaceAll(' ', '')) {
      case 'G':
        return AgeRating.g;
      case 'PG':
        return AgeRating.pg;
      case 'PG13':
        return AgeRating.pg13;
      case 'R':
        return AgeRating.r;
      case 'NC17':
        return AgeRating.nc17;
      case 'TVMA':
        return AgeRating.tvMa;
      case 'UNRATED':
        return AgeRating.unrated;
      default:
        return AgeRating.unknown;
    }
  }

  String get displayName {
    switch (this) {
      case AgeRating.g:
        return 'G';
      case AgeRating.pg:
        return 'PG';
      case AgeRating.pg13:
        return 'PG-13';
      case AgeRating.r:
        return 'R';
      case AgeRating.nc17:
        return 'NC-17';
      case AgeRating.tvMa:
        return 'TV-MA';
      case AgeRating.unrated:
      case AgeRating.unknown:
        return 'UNRATED';
    }
  }
}

enum SortBy {
  releaseDate,
  rating,
  title,
}

extension SortByExtension on SortBy {
  static SortBy fromString(String? value) {
    switch (value) {
      case 'rating':
        return SortBy.rating;
      case 'title':
        return SortBy.title;
      case 'release_date':
      default:
        return SortBy.releaseDate;
    }
  }

  String toRawValue() {
    switch (this) {
      case SortBy.releaseDate:
        return 'release_date';
      case SortBy.rating:
        return 'rating';
      case SortBy.title:
        return 'title';
    }
  }
}

enum SortOrder {
  asc,
  desc,
}

extension SortOrderExtension on SortOrder {
  static SortOrder fromString(String? value) {
    return value == 'asc' ? SortOrder.asc : SortOrder.desc;
  }

  String toRawValue() => name;
}
