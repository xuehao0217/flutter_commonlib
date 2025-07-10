import 'package:flutter_commonlib/generated/json/base/json_convert_content.dart';
import 'package:flutter_commonlib/entity/home_list_entity.dart';

HomeListData $HomeListDataFromJson(Map<String, dynamic> json) {
  final HomeListData homeListData = HomeListData();
  final int? curPage = jsonConvert.convert<int>(json['curPage']);
  if (curPage != null) {
    homeListData.curPage = curPage;
  }
  final List<HomeListDataDatas>? datas = (json['datas'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<HomeListDataDatas>(e) as HomeListDataDatas)
      .toList();
  if (datas != null) {
    homeListData.datas = datas;
  }
  final int? offset = jsonConvert.convert<int>(json['offset']);
  if (offset != null) {
    homeListData.offset = offset;
  }
  final bool? over = jsonConvert.convert<bool>(json['over']);
  if (over != null) {
    homeListData.over = over;
  }
  final int? pageCount = jsonConvert.convert<int>(json['pageCount']);
  if (pageCount != null) {
    homeListData.pageCount = pageCount;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    homeListData.size = size;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    homeListData.total = total;
  }
  return homeListData;
}

Map<String, dynamic> $HomeListDataToJson(HomeListData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['curPage'] = entity.curPage;
  data['datas'] = entity.datas.map((v) => v.toJson()).toList();
  data['offset'] = entity.offset;
  data['over'] = entity.over;
  data['pageCount'] = entity.pageCount;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension HomeListDataExtension on HomeListData {
  HomeListData copyWith({
    int? curPage,
    List<HomeListDataDatas>? datas,
    int? offset,
    bool? over,
    int? pageCount,
    int? size,
    int? total,
  }) {
    return HomeListData()
      ..curPage = curPage ?? this.curPage
      ..datas = datas ?? this.datas
      ..offset = offset ?? this.offset
      ..over = over ?? this.over
      ..pageCount = pageCount ?? this.pageCount
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}

HomeListDataDatas $HomeListDataDatasFromJson(Map<String, dynamic> json) {
  final HomeListDataDatas homeListDataDatas = HomeListDataDatas();
  final bool? adminAdd = jsonConvert.convert<bool>(json['adminAdd']);
  if (adminAdd != null) {
    homeListDataDatas.adminAdd = adminAdd;
  }
  final String? apkLink = jsonConvert.convert<String>(json['apkLink']);
  if (apkLink != null) {
    homeListDataDatas.apkLink = apkLink;
  }
  final int? audit = jsonConvert.convert<int>(json['audit']);
  if (audit != null) {
    homeListDataDatas.audit = audit;
  }
  final String? author = jsonConvert.convert<String>(json['author']);
  if (author != null) {
    homeListDataDatas.author = author;
  }
  final bool? canEdit = jsonConvert.convert<bool>(json['canEdit']);
  if (canEdit != null) {
    homeListDataDatas.canEdit = canEdit;
  }
  final int? chapterId = jsonConvert.convert<int>(json['chapterId']);
  if (chapterId != null) {
    homeListDataDatas.chapterId = chapterId;
  }
  final String? chapterName = jsonConvert.convert<String>(json['chapterName']);
  if (chapterName != null) {
    homeListDataDatas.chapterName = chapterName;
  }
  final bool? collect = jsonConvert.convert<bool>(json['collect']);
  if (collect != null) {
    homeListDataDatas.collect = collect;
  }
  final int? courseId = jsonConvert.convert<int>(json['courseId']);
  if (courseId != null) {
    homeListDataDatas.courseId = courseId;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    homeListDataDatas.desc = desc;
  }
  final String? descMd = jsonConvert.convert<String>(json['descMd']);
  if (descMd != null) {
    homeListDataDatas.descMd = descMd;
  }
  final String? envelopePic = jsonConvert.convert<String>(json['envelopePic']);
  if (envelopePic != null) {
    homeListDataDatas.envelopePic = envelopePic;
  }
  final bool? fresh = jsonConvert.convert<bool>(json['fresh']);
  if (fresh != null) {
    homeListDataDatas.fresh = fresh;
  }
  final String? host = jsonConvert.convert<String>(json['host']);
  if (host != null) {
    homeListDataDatas.host = host;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    homeListDataDatas.id = id;
  }
  final bool? isAdminAdd = jsonConvert.convert<bool>(json['isAdminAdd']);
  if (isAdminAdd != null) {
    homeListDataDatas.isAdminAdd = isAdminAdd;
  }
  final String? link = jsonConvert.convert<String>(json['link']);
  if (link != null) {
    homeListDataDatas.link = link;
  }
  final String? niceDate = jsonConvert.convert<String>(json['niceDate']);
  if (niceDate != null) {
    homeListDataDatas.niceDate = niceDate;
  }
  final String? niceShareDate = jsonConvert.convert<String>(
      json['niceShareDate']);
  if (niceShareDate != null) {
    homeListDataDatas.niceShareDate = niceShareDate;
  }
  final String? origin = jsonConvert.convert<String>(json['origin']);
  if (origin != null) {
    homeListDataDatas.origin = origin;
  }
  final String? prefix = jsonConvert.convert<String>(json['prefix']);
  if (prefix != null) {
    homeListDataDatas.prefix = prefix;
  }
  final String? projectLink = jsonConvert.convert<String>(json['projectLink']);
  if (projectLink != null) {
    homeListDataDatas.projectLink = projectLink;
  }
  final int? publishTime = jsonConvert.convert<int>(json['publishTime']);
  if (publishTime != null) {
    homeListDataDatas.publishTime = publishTime;
  }
  final int? realSuperChapterId = jsonConvert.convert<int>(
      json['realSuperChapterId']);
  if (realSuperChapterId != null) {
    homeListDataDatas.realSuperChapterId = realSuperChapterId;
  }
  final int? selfVisible = jsonConvert.convert<int>(json['selfVisible']);
  if (selfVisible != null) {
    homeListDataDatas.selfVisible = selfVisible;
  }
  final int? shareDate = jsonConvert.convert<int>(json['shareDate']);
  if (shareDate != null) {
    homeListDataDatas.shareDate = shareDate;
  }
  final String? shareUser = jsonConvert.convert<String>(json['shareUser']);
  if (shareUser != null) {
    homeListDataDatas.shareUser = shareUser;
  }
  final int? superChapterId = jsonConvert.convert<int>(json['superChapterId']);
  if (superChapterId != null) {
    homeListDataDatas.superChapterId = superChapterId;
  }
  final String? superChapterName = jsonConvert.convert<String>(
      json['superChapterName']);
  if (superChapterName != null) {
    homeListDataDatas.superChapterName = superChapterName;
  }
  final List<HomeListDataDatasTags>? tags = (json['tags'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<HomeListDataDatasTags>(e) as HomeListDataDatasTags)
      .toList();
  if (tags != null) {
    homeListDataDatas.tags = tags;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    homeListDataDatas.title = title;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    homeListDataDatas.type = type;
  }
  final int? userId = jsonConvert.convert<int>(json['userId']);
  if (userId != null) {
    homeListDataDatas.userId = userId;
  }
  final int? visible = jsonConvert.convert<int>(json['visible']);
  if (visible != null) {
    homeListDataDatas.visible = visible;
  }
  final int? zan = jsonConvert.convert<int>(json['zan']);
  if (zan != null) {
    homeListDataDatas.zan = zan;
  }
  return homeListDataDatas;
}

Map<String, dynamic> $HomeListDataDatasToJson(HomeListDataDatas entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['adminAdd'] = entity.adminAdd;
  data['apkLink'] = entity.apkLink;
  data['audit'] = entity.audit;
  data['author'] = entity.author;
  data['canEdit'] = entity.canEdit;
  data['chapterId'] = entity.chapterId;
  data['chapterName'] = entity.chapterName;
  data['collect'] = entity.collect;
  data['courseId'] = entity.courseId;
  data['desc'] = entity.desc;
  data['descMd'] = entity.descMd;
  data['envelopePic'] = entity.envelopePic;
  data['fresh'] = entity.fresh;
  data['host'] = entity.host;
  data['id'] = entity.id;
  data['isAdminAdd'] = entity.isAdminAdd;
  data['link'] = entity.link;
  data['niceDate'] = entity.niceDate;
  data['niceShareDate'] = entity.niceShareDate;
  data['origin'] = entity.origin;
  data['prefix'] = entity.prefix;
  data['projectLink'] = entity.projectLink;
  data['publishTime'] = entity.publishTime;
  data['realSuperChapterId'] = entity.realSuperChapterId;
  data['selfVisible'] = entity.selfVisible;
  data['shareDate'] = entity.shareDate;
  data['shareUser'] = entity.shareUser;
  data['superChapterId'] = entity.superChapterId;
  data['superChapterName'] = entity.superChapterName;
  data['tags'] = entity.tags.map((v) => v.toJson()).toList();
  data['title'] = entity.title;
  data['type'] = entity.type;
  data['userId'] = entity.userId;
  data['visible'] = entity.visible;
  data['zan'] = entity.zan;
  return data;
}

extension HomeListDataDatasExtension on HomeListDataDatas {
  HomeListDataDatas copyWith({
    bool? adminAdd,
    String? apkLink,
    int? audit,
    String? author,
    bool? canEdit,
    int? chapterId,
    String? chapterName,
    bool? collect,
    int? courseId,
    String? desc,
    String? descMd,
    String? envelopePic,
    bool? fresh,
    String? host,
    int? id,
    bool? isAdminAdd,
    String? link,
    String? niceDate,
    String? niceShareDate,
    String? origin,
    String? prefix,
    String? projectLink,
    int? publishTime,
    int? realSuperChapterId,
    int? selfVisible,
    int? shareDate,
    String? shareUser,
    int? superChapterId,
    String? superChapterName,
    List<HomeListDataDatasTags>? tags,
    String? title,
    int? type,
    int? userId,
    int? visible,
    int? zan,
  }) {
    return HomeListDataDatas()
      ..adminAdd = adminAdd ?? this.adminAdd
      ..apkLink = apkLink ?? this.apkLink
      ..audit = audit ?? this.audit
      ..author = author ?? this.author
      ..canEdit = canEdit ?? this.canEdit
      ..chapterId = chapterId ?? this.chapterId
      ..chapterName = chapterName ?? this.chapterName
      ..collect = collect ?? this.collect
      ..courseId = courseId ?? this.courseId
      ..desc = desc ?? this.desc
      ..descMd = descMd ?? this.descMd
      ..envelopePic = envelopePic ?? this.envelopePic
      ..fresh = fresh ?? this.fresh
      ..host = host ?? this.host
      ..id = id ?? this.id
      ..isAdminAdd = isAdminAdd ?? this.isAdminAdd
      ..link = link ?? this.link
      ..niceDate = niceDate ?? this.niceDate
      ..niceShareDate = niceShareDate ?? this.niceShareDate
      ..origin = origin ?? this.origin
      ..prefix = prefix ?? this.prefix
      ..projectLink = projectLink ?? this.projectLink
      ..publishTime = publishTime ?? this.publishTime
      ..realSuperChapterId = realSuperChapterId ?? this.realSuperChapterId
      ..selfVisible = selfVisible ?? this.selfVisible
      ..shareDate = shareDate ?? this.shareDate
      ..shareUser = shareUser ?? this.shareUser
      ..superChapterId = superChapterId ?? this.superChapterId
      ..superChapterName = superChapterName ?? this.superChapterName
      ..tags = tags ?? this.tags
      ..title = title ?? this.title
      ..type = type ?? this.type
      ..userId = userId ?? this.userId
      ..visible = visible ?? this.visible
      ..zan = zan ?? this.zan;
  }
}

HomeListDataDatasTags $HomeListDataDatasTagsFromJson(
    Map<String, dynamic> json) {
  final HomeListDataDatasTags homeListDataDatasTags = HomeListDataDatasTags();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    homeListDataDatasTags.name = name;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    homeListDataDatasTags.url = url;
  }
  return homeListDataDatasTags;
}

Map<String, dynamic> $HomeListDataDatasTagsToJson(
    HomeListDataDatasTags entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['url'] = entity.url;
  return data;
}

extension HomeListDataDatasTagsExtension on HomeListDataDatasTags {
  HomeListDataDatasTags copyWith({
    String? name,
    String? url,
  }) {
    return HomeListDataDatasTags()
      ..name = name ?? this.name
      ..url = url ?? this.url;
  }
}