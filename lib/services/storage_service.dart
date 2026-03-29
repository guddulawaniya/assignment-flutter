import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

/// StorageService — abstraction over SharedPreferences for local persistence.
/// Equivalent to React Native StorageService (MMKV).
class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getString(String key) {
    try {
      return _prefs?.getString(key);
    } catch (e) {
      Logger.error('StorageService.getString failed for key: $key', e);
      return null;
    }
  }

  static void setString(String key, String value) {
    try {
      _prefs?.setString(key, value);
    } catch (e) {
      Logger.error('StorageService.setString failed for key: $key', e);
    }
  }

  static T? getObject<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final raw = _prefs?.getString(key);
      if (raw != null) {
        return fromJson(jsonDecode(raw) as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      Logger.error('StorageService.getObject failed for key: $key', e);
      return null;
    }
  }

  static List<T>? getObjectList<T>(
      String key, T Function(Map<String, dynamic>) fromJson) {
    try {
      final raw = _prefs?.getString(key);
      if (raw != null) {
        final list = jsonDecode(raw) as List<dynamic>;
        return list
            .map((e) => fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return null;
    } catch (e) {
      Logger.error('StorageService.getObjectList failed for key: $key', e);
      return null;
    }
  }

  static void setObjectList<T>(
      String key, List<T> value, Map<String, dynamic> Function(T) toJson) {
    try {
      final jsonList = value.map((e) => toJson(e)).toList();
      _prefs?.setString(key, jsonEncode(jsonList));
    } catch (e) {
      Logger.error('StorageService.setObjectList failed for key: $key', e);
    }
  }

  static void setObject(String key, Map<String, dynamic> value) {
    try {
      _prefs?.setString(key, jsonEncode(value));
    } catch (e) {
      Logger.error('StorageService.setObject failed for key: $key', e);
    }
  }

  static void delete(String key) {
    try {
      _prefs?.remove(key);
    } catch (e) {
      Logger.error('StorageService.delete failed for key: $key', e);
    }
  }

  static bool contains(String key) {
    try {
      return _prefs?.containsKey(key) ?? false;
    } catch (e) {
      Logger.error('StorageService.contains failed for key: $key', e);
      return false;
    }
  }

  static void clearAll() {
    try {
      _prefs?.clear();
    } catch (e) {
      Logger.error('StorageService.clearAll failed', e);
    }
  }
}
