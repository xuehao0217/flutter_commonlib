import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// 保存对象
// await SPUtil.putObject("user", user.toJson());
//
// // 读取对象
// final userMap = await SPUtil.getObject("user");
// final user = userMap != null ? UserEntity.fromJson(userMap) : null;
//
// // 保存列表
// await SPUtil.putObjectList("news_list", newsList.map((e) => e.toJson()).toList());
//
// // 读取列表
// final list = await SPUtil.getObjectList("news_list");
// final newsList = list?.map((e) => NewsContentNews.fromJson(e)).toList() ?? [];
//

class SPUtil {
  SPUtil._(); // 私有构造

  static SharedPreferences? _prefs;

  /// 异步初始化，建议在 main() 里调用
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// ---------- 基础类型 ----------
  static Future<void> putString(String key, String value) async {
    final prefs = await _instance;
    await prefs.setString(key, value);
  }

  static Future<String> getString(String key, {String defaultValue = ""}) async {
    final prefs = await _instance;
    return prefs.getString(key) ?? defaultValue;
  }

  static Future<void> putInt(String key, int value) async {
    final prefs = await _instance;
    await prefs.setInt(key, value);
  }

  static Future<int> getInt(String key, {int defaultValue = 0}) async {
    final prefs = await _instance;
    return prefs.getInt(key) ?? defaultValue;
  }

  static Future<void> putBool(String key, bool value) async {
    final prefs = await _instance;
    await prefs.setBool(key, value);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await _instance;
    return prefs.getBool(key) ?? defaultValue;
  }

  static Future<void> putDouble(String key, double value) async {
    final prefs = await _instance;
    await prefs.setDouble(key, value);
  }

  static Future<double> getDouble(String key, {double defaultValue = 0.0}) async {
    final prefs = await _instance;
    return prefs.getDouble(key) ?? defaultValue;
  }

  static Future<void> putStringList(String key, List<String> value) async {
    final prefs = await _instance;
    await prefs.setStringList(key, value);
  }

  static Future<List<String>> getStringList(String key, {List<String> defaultValue = const []}) async {
    final prefs = await _instance;
    return prefs.getStringList(key) ?? defaultValue;
  }

  /// ---------- JSON 对象 ----------
  static Future<void> putObject(String key, Object value) async {
    final jsonString = jsonEncode(value);
    await putString(key, jsonString);
  }

  static Future<Map<String, dynamic>?> getObject(String key) async {
    final jsonString = await getString(key, defaultValue: '');
    if (jsonString.isEmpty) return null;
    return jsonDecode(jsonString);
  }

  static Future<void> putObjectList(String key, List<Object> list) async {
    final jsonString = jsonEncode(list);
    await putString(key, jsonString);
  }

  static Future<List<dynamic>?> getObjectList(String key) async {
    final jsonString = await getString(key, defaultValue: '');
    if (jsonString.isEmpty) return null;
    return jsonDecode(jsonString);
  }

  /// ---------- 公共操作 ----------
  static Future<void> remove(String key) async {
    final prefs = await _instance;
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await _instance;
    await prefs.clear();
  }
}
