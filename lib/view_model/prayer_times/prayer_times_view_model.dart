import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'states.dart';

class PrayerTimesViewModel extends ChangeNotifier {
  PrayerTimesViewModel() {
    states = PrayerTimesStates.Initial;
  }

  PrayerTimesStates states;

  Position _currentPosition;

  Position get currentPosition => _currentPosition;

  PrayerTimes prayerTimes;
  bool serviceEnabled;
  LocationPermission permission;
  final params = CalculationMethod.egyptian.getParameters();

  Future<void> determinePosition() async {
    states = PrayerTimesStates.Loading;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      states = PrayerTimesStates.Error;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        states = PrayerTimesStates.Error;
      }
      if (permission == LocationPermission.denied) {
        states = PrayerTimesStates.Error;
      }
    }
    try {
      states = PrayerTimesStates.Loading;
      _currentPosition = await Geolocator.getCurrentPosition();
      params.madhab = Madhab.hanafi;
      prayerTimes = PrayerTimes.today(
          Coordinates(_currentPosition.latitude, _currentPosition.longitude),
          params);
      states = PrayerTimesStates.Success;
    } catch (locationException) {
      states = PrayerTimesStates.Error;
    }
    notifyListeners();
  }
}
