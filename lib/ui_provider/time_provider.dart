import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class TimeProvider extends ChangeNotifier {
  Timer timer;
  TimeOfDay timeOfDay = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  void initializeTimer() {
    period();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      dateTime = DateTime.now();
      if (timeOfDay.minute != TimeOfDay.now().minute) {
        timeOfDay = TimeOfDay.now();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  String period() {
    return timeOfDay.period == DayPeriod.am ? 'am'.tr() : 'pm'.tr();
  }

  void disposeData() {
    timer.cancel();
  }
}
