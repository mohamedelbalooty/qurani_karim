import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/repositories/quran/local_service.dart';
import 'package:qurany_karim/repositories/quran/remote_service.dart';
import 'package:qurany_karim/utils/constants/cache_keys.dart';
import 'package:qurany_karim/utils/helper/cache_helper.dart';
import 'states.dart';

class QuranViewModel extends ChangeNotifier {
  QuranGetRemoteDataStates remoteDataStates;
  QuranGetLocalDataStates localDataStates;
  QuranGetCachedSurahDataStates cachedSurahDataStates;
  List<Surah> _quranData;

  List<Surah> get quranData => _quranData;

  Surah _cachedSurah;

  Surah get cachedSurah => _cachedSurah;

  ErrorResult _error;

  ErrorResult get error => _error;

  QuranRemoteService _remoteService = QuranRemoteService();
  QuranLocalService _localService = QuranLocalService();

  Future<void> getRemoteData() async {
    remoteDataStates = QuranGetRemoteDataStates.Loading;
    notifyListeners();
    await _remoteService.getQuranData().then((value) {
      value.fold((left) {
        CacheHelper.setBooleanData(key: isCachingQuran, value: true);
        _localService.cachingQuranData(data: left);
        remoteDataStates = QuranGetRemoteDataStates.Loaded;
      }, (right) {
        _error = right;
        remoteDataStates = QuranGetRemoteDataStates.Error;
      });
    });
    notifyListeners();
  }

  Future<void> getLocalData() async {
    localDataStates = QuranGetLocalDataStates.Loading;
    notifyListeners();
    await _localService.getQuranData().then((value) {
      value.fold((left) {
        _quranData = left;
        localDataStates = QuranGetLocalDataStates.Loaded;
      }, (right) {
        _error = right;
        print(right);
        localDataStates = QuranGetLocalDataStates.Error;
      });
    });
    notifyListeners();
  }

  void cachingSurah({@required int surahId}) {
    CacheHelper.setIntData(key: isCachingSurahText, value: surahId);
  }

  Future<void> getSurahData() async {
    await _localService
        .getSurahData(CacheHelper.getIntData(key: isCachingSurahText))
        .then((value) {
      value.fold((left) {
        _cachedSurah = left;
        cachedSurahDataStates = QuranGetCachedSurahDataStates.Loaded;
      }, (right) {
        _error = right;
        cachedSurahDataStates = QuranGetCachedSurahDataStates.Error;
      });
    });
    notifyListeners();
  }

  void disposeData() async {
    Box<Surah> box = await Hive.openBox<Surah>(quranResponse);
    _quranData.clear();
    box.close();
  }
}
