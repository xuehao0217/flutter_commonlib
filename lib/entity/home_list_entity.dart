import 'package:flutter_commonlib/generated/json/base/json_field.dart';
import 'package:flutter_commonlib/generated/json/home_list_entity.g.dart';
import 'dart:convert';
export 'package:flutter_commonlib/generated/json/home_list_entity.g.dart';

@JsonSerializable()
class HomeListData {
	late int curPage = 0;
	late List<HomeListDataDatas> datas = [];
	late int offset = 0;
	late bool over = false;
	late int pageCount = 0;
	late int size = 0;
	late int total = 0;

	HomeListData();

	factory HomeListData.fromJson(Map<String, dynamic> json) => $HomeListDataFromJson(json);

	Map<String, dynamic> toJson() => $HomeListDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomeListDataDatas {
	late bool adminAdd = false;
	late String apkLink = '';
	late int audit = 0;
	late String author = '';
	late bool canEdit = false;
	late int chapterId = 0;
	late String chapterName = '';
	late bool collect = false;
	late int courseId = 0;
	late String desc = '';
	late String descMd = '';
	late String envelopePic = '';
	late bool fresh = false;
	late String host = '';
	late int id = 0;
	late bool isAdminAdd = false;
	late String link = '';
	late String niceDate = '';
	late String niceShareDate = '';
	late String origin = '';
	late String prefix = '';
	late String projectLink = '';
	late int publishTime = 0;
	late int realSuperChapterId = 0;
	late int selfVisible = 0;
	late int shareDate = 0;
	late String shareUser = '';
	late int superChapterId = 0;
	late String superChapterName = '';
	late List<HomeListDataDatasTags> tags = [];
	late String title = '';
	late int type = 0;
	late int userId = 0;
	late int visible = 0;
	late int zan = 0;

	HomeListDataDatas();

	factory HomeListDataDatas.fromJson(Map<String, dynamic> json) => $HomeListDataDatasFromJson(json);

	Map<String, dynamic> toJson() => $HomeListDataDatasToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomeListDataDatasTags {
	late String name = '';
	late String url = '';

	HomeListDataDatasTags();

	factory HomeListDataDatasTags.fromJson(Map<String, dynamic> json) => $HomeListDataDatasTagsFromJson(json);

	Map<String, dynamic> toJson() => $HomeListDataDatasTagsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}