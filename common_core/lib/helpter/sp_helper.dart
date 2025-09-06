import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

typedef FromJson<T> = T Function(Map<String, dynamic> json);

class SPUtil {
  SPUtil._();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// ---------- 基础类型 ----------
  static Future<void> putString(String key, String value) async =>
      (await _instance).setString(key, value);
  static Future<String> getString(String key, {String defaultValue = ""}) async =>
      (await _instance).getString(key) ?? defaultValue;

  static Future<void> putInt(String key, int value) async =>
      (await _instance).setInt(key, value);
  static Future<int> getInt(String key, {int defaultValue = 0}) async =>
      (await _instance).getInt(key) ?? defaultValue;

  static Future<void> putBool(String key, bool value) async =>
      (await _instance).setBool(key, value);
  static Future<bool> getBool(String key, {bool defaultValue = false}) async =>
      (await _instance).getBool(key) ?? defaultValue;

  static Future<void> putDouble(String key, double value) async =>
      (await _instance).setDouble(key, value);
  static Future<double> getDouble(String key, {double defaultValue = 0.0}) async =>
      (await _instance).getDouble(key) ?? defaultValue;

  static Future<void> putStringList(String key, List<String> value) async =>
      (await _instance).setStringList(key, value);
  static Future<List<String>> getStringList(String key, {List<String> defaultValue = const []}) async =>
      (await _instance).getStringList(key) ?? defaultValue;

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

  /// ---------- 泛型对象 ----------
  static Future<void> saveObject<T>(String key, T object) async {
    final jsonString = jsonEncode((object as dynamic).toJson());
    await putString(key, jsonString);
  }

  static Future<T?> getObjectGeneric<T>(String key, FromJson<T> fromJson) async {
    final jsonString = await getString(key);
    if (jsonString.isEmpty) return null;
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return fromJson(jsonMap);
  }

  static Future<void> saveList<T>(String key, List<T> list) async {
    final jsonList = list.map((e) => (e as dynamic).toJson()).toList();
    await putString(key, jsonEncode(jsonList));
  }

  static Future<List<T>> getList<T>(String key, FromJson<T> fromJson) async {
    final jsonString = await getString(key);
    if (jsonString.isEmpty) return [];
    final List<dynamic> jsonData = jsonDecode(jsonString);
    return jsonData.map((e) => fromJson(e)).toList();
  }

  /// ---------- 公共操作 ----------
  static Future<void> remove(String key) async => (await _instance).remove(key);
  static Future<void> clearAll() async => (await _instance).clear();
}
