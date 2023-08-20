import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:timer_app/model/timer_model.dart';
import 'package:timer_app/utils/locator.dart';

class TimerProvider with ChangeNotifier {
  List<TimerModel> timerList = [];

  loadTimerItems() {
    List<Map<String, dynamic>> timerMap = [];
    if (localStorageService.getTimerItemFromDisk != null) {
      final employeeDetail = localStorageService.getTimerItemFromDisk;
      for (var item in employeeDetail!) {
        timerMap.add(jsonDecode(item));
      }
      timerList = timerMap
          .map((item) => TimerModel(
                id: item['id'],
                minutes: item['minutes'],
                seconds: item['seconds'],
              ))
          .toList();
      print(timerList);
    }
    notifyListeners();
  }

  void addTimerItems(TimerModel item) {
    if (timerList.length >= 10) {
      return;
    }
    timerList.add(item);
    List<String> jsonDataList = [];
    if (localStorageService.getTimerItemFromDisk != null) {
      jsonDataList = localStorageService.getTimerItemFromDisk!;
      jsonDataList.add(jsonEncode(item));
      localStorageService.saveTimerItemToDisk(jsonDataList);
    } else {
      jsonDataList.add(jsonEncode(item));
      localStorageService.saveTimerItemToDisk(jsonDataList);
    }
    loadTimerItems();
  }

  removeAllTimerItems() {
    if (localStorageService.getTimerItemFromDisk != null) {
      timerList.clear();
      List<String> jsonDataList = [];
      localStorageService.saveTimerItemToDisk(jsonDataList);
      notifyListeners();
    }
  }
}
