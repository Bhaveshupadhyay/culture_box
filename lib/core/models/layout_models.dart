import 'package:equatable/equatable.dart';
import 'enums.dart';
import 'movie_models.dart';

class LayoutSectionModel extends Equatable {
  final String sectionId;
  final String sectionName;
  final WidgetType widgetType;
  final ScrollType scrollType;
  final String? dataEndpoint;

  const LayoutSectionModel({
    required this.sectionId,
    required this.sectionName,
    required this.widgetType,
    required this.scrollType,
    this.dataEndpoint,
  });

  factory LayoutSectionModel.fromJson(Map<String, dynamic> json) {
    return LayoutSectionModel(
      sectionId: json['section_id'] as String? ?? json['id']?.toString() ?? '',
      sectionName: json['section_name'] as String? ?? json['row_title'] as String? ?? '',
      widgetType: WidgetTypeExtension.fromString(json['widget_type'] as String? ?? json['content_source'] as String?),
      scrollType: ScrollTypeExtension.fromString(json['scroll_type'] as String?),
      dataEndpoint: json['data_endpoint'] as String? ?? json['id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'section_id': sectionId,
      'section_name': sectionName,
      'widget_type': widgetType.toRawValue(),
      'scroll_type': scrollType.toRawValue(),
      'data_endpoint': dataEndpoint,
    };
  }

  @override
  List<Object?> get props => [sectionId, sectionName, widgetType, scrollType, dataEndpoint];
}

class HomeLayoutRowModel extends Equatable {
  final int id;
  final String rowTitle;
  final String contentSource;
  final int sourceId;
  final String aspectRatio;

  const HomeLayoutRowModel({
    required this.id,
    required this.rowTitle,
    required this.contentSource,
    required this.sourceId,
    required this.aspectRatio,
  });

  factory HomeLayoutRowModel.fromJson(Map<String, dynamic> json) {
    return HomeLayoutRowModel(
      id: json['id'] as int? ?? 0,
      rowTitle: json['row_title'] as String? ?? '',
      contentSource: json['content_source'] as String? ?? '',
      sourceId: json['source_id'] as int? ?? 0,
      aspectRatio: json['aspect_ratio'] as String? ?? '9:16',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'row_title': rowTitle,
      'content_source': contentSource,
      'source_id': sourceId,
      'aspect_ratio': aspectRatio,
    };
  }

  LayoutSectionModel toLayoutSection() {
    final parsedWidget = WidgetTypeExtension.fromString(contentSource);
    final resolvedWidget = parsedWidget == WidgetType.unknown ? WidgetType.horizontalList : parsedWidget;

    return LayoutSectionModel(
      sectionId: id.toString(),
      sectionName: rowTitle,
      widgetType: resolvedWidget,
      scrollType: ScrollType.horizontal,
      dataEndpoint: id.toString(),
    );
  }

  @override
  List<Object?> get props => [id, rowTitle, contentSource, sourceId, aspectRatio];
}

class HomepageLayoutResponseModel extends Equatable {
  final List<LayoutSectionModel> sections;

  const HomepageLayoutResponseModel({
    required this.sections,
  });

  factory HomepageLayoutResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['sections'] as List? ?? json['data'] as List? ?? [])
        .map((e) => LayoutSectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return HomepageLayoutResponseModel(sections: list);
  }

  Map<String, dynamic> toJson() {
    return {
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [sections];
}

class HomeSliderModel extends Equatable {
  final int id;
  final int position;
  final String title;
  final String description;
  final String? backdropUrl;
  final String contentType;
  final String? rating;
  final int? releaseDate;
  final String? subCategories;

  const HomeSliderModel({
    required this.id,
    required this.position,
    required this.title,
    required this.description,
    this.backdropUrl,
    required this.contentType,
    this.rating,
    this.releaseDate,
    this.subCategories,
  });

  factory HomeSliderModel.fromJson(Map<String, dynamic> json) {
    return HomeSliderModel(
      id: json['id'] as int? ?? 0,
      position: json['position'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      backdropUrl: json['backdrop_url'] as String?,
      contentType: json['content_type'] as String? ?? 'movie',
      rating: json['rating'] as String?,
      releaseDate: json['release_date'] as int?,
      subCategories: json['sub_categories'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'position': position,
      'title': title,
      'description': description,
      'backdrop_url': backdropUrl,
      'content_type': contentType,
      'rating': rating,
      'release_date': releaseDate,
      'sub_categories': subCategories,
    };
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
      isOriginal: true,
      isTrending: true,
    );
  }

  @override
  List<Object?> get props => [
        id,
        position,
        title,
        description,
        backdropUrl,
        contentType,
        rating,
        releaseDate,
        subCategories,
      ];
}
