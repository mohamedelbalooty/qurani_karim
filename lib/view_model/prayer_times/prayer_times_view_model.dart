import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'states.dart';

class PrayerTimesViewModel extends ChangeNotifier {
  late PrayerTimesStates states;

  PrayerTimesViewModel() {
    states = PrayerTimesStates.Initial;
  }

  Position? _currentPosition;

  Position get currentPosition => _currentPosition!;

  late PrayerTimes prayerTimes;
  late bool serviceEnabled;
  late LocationPermission permission;
  final params = CalculationMethodParameters.muslimWorldLeague();

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
      prayerTimes = PrayerTimes(
        date: DateTime.now(),
        coordinates: Coordinates(
            _currentPosition!.latitude, _currentPosition!.longitude),
        calculationParameters: params,
        precision: true,
      );
      states = PrayerTimesStates.Success;
    } catch (locationException) {
      states = PrayerTimesStates.Error;
    }
    notifyListeners();
  }
}
