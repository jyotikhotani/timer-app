import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static late LocalStorageService _instance;
  static late SharedPreferences _preferences;

  static String timerData = "TimerData";

  static Future<LocalStorageService> getInstance() async {
    _instance = LocalStorageService();
    _preferences = await SharedPreferences.getInstance();
    return _instance;
  }

  void saveTimerItemToDisk(List<String> userDataList) {
    _saveToDisk(timerData, userDataList);
  }

  List<String>? get getTimerItemFromDisk {
    List<String>? data = _preferences.getStringList(timerData);

    return data;
  }

  void _saveToDisk<T>(String key, T content) {
    log('(TRACE) LocalStorageService:_saveToDisk. key: $key value: $content');

    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }
}
