import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/model/surah_audio.dart';
import 'package:qurany_karim/repositories/surah_audio/remote_service.dart';
import 'package:qurany_karim/utils/constants/cache_keys.dart';
import 'package:qurany_karim/utils/helper/cache_helper.dart';
import 'states.dart';

class AudioViewModel extends ChangeNotifier {
  AudioDataStates audioDataStates;
  PlayState playState = PlayState.Initial;

  SurahAudioRemoteService _service = SurahAudioRemoteService();

  List<AyahAudio> _surahAudio;

  List<AyahAudio> get surahAudio => _surahAudio;

  ErrorResult _error;

  ErrorResult get error => _error;

  List<Surah> _displayQuranData;

  List<Surah> get displayQuranData => _displayQuranData;

  Surah _surah;

  Surah get surah => _surah;

  bool openedAudio = false;
  bool isPlaying = false;

  void initializeQuranData(List<Surah> data) {
    _displayQuranData = data;
  }

  void isOpenedAudio() {
    openedAudio = true;
    notifyListeners();
  }

  Future<void> getSurahAudio(
      {@required int surahId, @required String elderFormat}) async {
    audioDataStates = AudioDataStates.Loading;
    notifyListeners();
    await _service
        .getSurahAudio(surahId: surahId, elderFormat: elderFormat)
        .then((value) {
      value.fold((left) {
        _surahAudio = left;
        CacheHelper.setIntData(key: isCachingSurahAudio, value: surahId);
        audioDataStates = AudioDataStates.Loaded;
      }, (right) {
        _error = right;
        audioDataStates = AudioDataStates.Error;
      });
    });
    notifyListeners();
  }

  Future<void> selectSurah({int id, @required String elderFormat}) async {
    player.stop();
    isPlaying = false;
    for (var item in displayQuranData) {
      if (item.number == id) {
        _surah = item;
      }
    }
    await getSurahAudio(elderFormat: elderFormat, surahId: id).then((value) {
      if (audioDataStates == AudioDataStates.Error) {
        for (var item in displayQuranData) {
          if (item.number == CacheHelper.getIntData(key: isCachingSurahAudio)) {
            _surah = item;
          }
        }
      }
      notifyListeners();
    });
    notifyListeners();
  }

  AssetsAudioPlayer player = AssetsAudioPlayer();

  void playSurahAudio() async {
    isPlaying = !isPlaying;
    playState = PlayState.Playing;
    try {
      await player.open(
        Playlist(
          audios: _surahAudio.map((e) => Audio.network(e.audio)).toList(),
          startIndex: 0,
        ),
        loopMode: LoopMode.none,
        showNotification: true,
        notificationSettings: const NotificationSettings(
            playPauseEnabled: true,
            stopEnabled: true,
            nextEnabled: false,
            prevEnabled: false),
      );
    } catch (audioException) {
      isPlaying = false;
      playState = PlayState.Initial;
    }
    listenOnAudioStates();
    notifyListeners();
  }

  listenOnAudioStates() {
    player.playerState.listen((state) {
      if (state == PlayerState.stop) {
        isPlaying = false;
        playState = PlayState.Ended;
      }
      notifyListeners();
    });
  }

  Future<void> pauseAudio() async {
    await player.playOrPause();
    isPlaying = !isPlaying;
    playState = PlayState.Paused;
    notifyListeners();
  }

  Future<void> stopAudio() async {
    await player.stop();
  }

  void disposeData() {
    stopAudio();
    openedAudio = false;
    isPlaying = false;
    _surah = null;
    _displayQuranData.clear();
  }
}
