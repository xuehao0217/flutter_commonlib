import 'package:flutter_commonlib/generated/json/base/json_field.dart';
import 'package:flutter_commonlib/generated/json/home_banner_entity.g.dart';
import 'dart:convert';
export 'package:flutter_commonlib/generated/json/home_banner_entity.g.dart';

@JsonSerializable()
class HomeBannerData {
	late String desc = '';
	late int id = 0;
	late String imagePath = '';
	late int isVisible = 0;
	late int order = 0;
	late String title = '';
	late int type = 0;
	late String url = '';

	HomeBannerData();

	factory HomeBannerData.fromJson(Map<String, dynamic> json) => $HomeBannerDataFromJson(json);

	Map<String, dynamic> toJson() => $HomeBannerDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}