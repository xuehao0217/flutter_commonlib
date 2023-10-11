import 'package:flutter_commonlib/generated/json/base/json_field.dart';
import 'package:flutter_commonlib/generated/json/home_banner_entity.g.dart';
import 'dart:convert';
export 'package:flutter_commonlib/generated/json/home_banner_entity.g.dart';

@JsonSerializable()
class HomeBannerEntity {
	late String desc = '';
	late double id;
	late String imagePath = '';
	late double isVisible;
	late double order;
	late String title = '';
	late double type;
	late String url = '';

	HomeBannerEntity();

	factory HomeBannerEntity.fromJson(Map<String, dynamic> json) => $HomeBannerEntityFromJson(json);

	Map<String, dynamic> toJson() => $HomeBannerEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}