import 'package:flutter/material.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/model/surah_audio.dart';
import 'package:qurany_karim/repositories/surah_audio/remote_service.dart';

import 'states.dart';

class AudioViewModel extends ChangeNotifier {
  AudioDataStates audioDataStates;
  bool isPlaying = false;
  Surah surah;

  void isPlayingChanging() {
    isPlaying = true;
    notifyListeners();
  }

  void selectSurahId(Surah selected) {
    surah = selected;
    notifyListeners();
  }

  List<AyahAudio> _surahAudio;

  List<AyahAudio> get surahAudio => _surahAudio;

  ErrorResult _error;

  ErrorResult get error => _error;

  SurahAudioRemoteService _service = SurahAudioRemoteService();

  Future<void> getSurahAudio(
      {@required int surahId, @required String elderFormat}) async {
    audioDataStates = AudioDataStates.Loading;
    notifyListeners();
    await _service
        .getSurahAudio(surahId: surahId, elderFormat: elderFormat)
        .then((value) {
      value.fold((left) {
        _surahAudio = left;
        audioDataStates = AudioDataStates.Loaded;
      }, (right) {
        _error = right;
        audioDataStates = AudioDataStates.Error;
      });
    });
    notifyListeners();
  }

  void disposeData() {
    isPlaying = false;
    surah = null;
  }
}
