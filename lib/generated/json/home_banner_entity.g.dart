import 'package:flutter_commonlib/generated/json/base/json_convert_content.dart';
import 'package:flutter_commonlib/entity/home_banner_entity.dart';

HomeBannerData $HomeBannerDataFromJson(Map<String, dynamic> json) {
  final HomeBannerData homeBannerData = HomeBannerData();
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    homeBannerData.desc = desc;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    homeBannerData.id = id;
  }
  final String? imagePath = jsonConvert.convert<String>(json['imagePath']);
  if (imagePath != null) {
    homeBannerData.imagePath = imagePath;
  }
  final int? isVisible = jsonConvert.convert<int>(json['isVisible']);
  if (isVisible != null) {
    homeBannerData.isVisible = isVisible;
  }
  final int? order = jsonConvert.convert<int>(json['order']);
  if (order != null) {
    homeBannerData.order = order;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    homeBannerData.title = title;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    homeBannerData.type = type;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    homeBannerData.url = url;
  }
  return homeBannerData;
}

Map<String, dynamic> $HomeBannerDataToJson(HomeBannerData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['desc'] = entity.desc;
  data['id'] = entity.id;
  data['imagePath'] = entity.imagePath;
  data['isVisible'] = entity.isVisible;
  data['order'] = entity.order;
  data['title'] = entity.title;
  data['type'] = entity.type;
  data['url'] = entity.url;
  return data;
}

extension HomeBannerDataExtension on HomeBannerData {
  HomeBannerData copyWith({
    String? desc,
    int? id,
    String? imagePath,
    int? isVisible,
    int? order,
    String? title,
    int? type,
    String? url,
  }) {
    return HomeBannerData()
      ..desc = desc ?? this.desc
      ..id = id ?? this.id
      ..imagePath = imagePath ?? this.imagePath
      ..isVisible = isVisible ?? this.isVisible
      ..order = order ?? this.order
      ..title = title ?? this.title
      ..type = type ?? this.type
      ..url = url ?? this.url;
  }
}