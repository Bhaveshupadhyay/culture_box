import 'package:equatable/equatable.dart';
import 'enums.dart';

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
      sectionId: json['section_id'] as String,
      sectionName: json['section_name'] as String,
      widgetType: WidgetTypeExtension.fromString(json['widget_type'] as String?),
      scrollType: ScrollTypeExtension.fromString(json['scroll_type'] as String?),
      dataEndpoint: json['data_endpoint'] as String?,
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

class HomepageLayoutResponseModel extends Equatable {
  final List<LayoutSectionModel> sections;

  const HomepageLayoutResponseModel({
    required this.sections,
  });

  factory HomepageLayoutResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['sections'] as List? ?? [])
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
