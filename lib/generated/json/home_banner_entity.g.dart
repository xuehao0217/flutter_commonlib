import 'package:flutter_commonlib/generated/json/base/json_convert_content.dart';
import 'package:flutter_commonlib/entity/home_banner_entity.dart';

HomeBannerEntity $HomeBannerEntityFromJson(Map<String, dynamic> json) {
  final HomeBannerEntity homeBannerEntity = HomeBannerEntity();
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    homeBannerEntity.desc = desc;
  }
  final double? id = jsonConvert.convert<double>(json['id']);
  if (id != null) {
    homeBannerEntity.id = id;
  }
  final String? imagePath = jsonConvert.convert<String>(json['imagePath']);
  if (imagePath != null) {
    homeBannerEntity.imagePath = imagePath;
  }
  final double? isVisible = jsonConvert.convert<double>(json['isVisible']);
  if (isVisible != null) {
    homeBannerEntity.isVisible = isVisible;
  }
  final double? order = jsonConvert.convert<double>(json['order']);
  if (order != null) {
    homeBannerEntity.order = order;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    homeBannerEntity.title = title;
  }
  final double? type = jsonConvert.convert<double>(json['type']);
  if (type != null) {
    homeBannerEntity.type = type;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    homeBannerEntity.url = url;
  }
  return homeBannerEntity;
}

Map<String, dynamic> $HomeBannerEntityToJson(HomeBannerEntity entity) {
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

extension HomeBannerEntityExtension on HomeBannerEntity {
  HomeBannerEntity copyWith({
    String? desc,
    double? id,
    String? imagePath,
    double? isVisible,
    double? order,
    String? title,
    double? type,
    String? url,
  }) {
    return HomeBannerEntity()
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