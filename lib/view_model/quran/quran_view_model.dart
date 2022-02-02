import 'package:flutter/material.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/repositories/quran/local_service.dart';
import 'package:qurany_karim/repositories/quran/remote_service.dart';
import 'states.dart';

class QuranViewModel extends ChangeNotifier {
  QuranGetRemoteDataStates remoteDataStates;
  List<Surah> _quranData;

  List<Surah> get quranData => _quranData;

  ErrorResult _error;

  ErrorResult get error => _error;

  QuranRemoteService _remoteService = QuranRemoteService();
  QuranLocalService _localService = QuranLocalService();

  Future<void> getRemoteData() async {
    remoteDataStates = QuranGetRemoteDataStates.Loading;
    notifyListeners();
    await _remoteService.getQuranData().then((value) {
      value.fold((left) {
        _quranData = left;
        remoteDataStates = QuranGetRemoteDataStates.Loaded;
      }, (right) {
        _error = right;
        remoteDataStates = QuranGetRemoteDataStates.Error;
      });
    });
    notifyListeners();
  }

  Future<void> getLocalData() async {}
}
