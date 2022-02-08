import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'states.dart';

class RadioViewModel extends ChangeNotifier {
  RadioViewModel() {
    states = RadioStates.Initial;
  }

  RadioStates states;
  final String streamUrl = 'http://livstream.xyz:8000/192k.mp3';

  Future<void> playRadio(AssetsAudioPlayer assetsAudioPlayer) async {
    states = RadioStates.Loading;
    try {
      await assetsAudioPlayer.open(
        Audio.liveStream(streamUrl),
        showNotification: true,
        notificationSettings: const NotificationSettings(
            playPauseEnabled: true,
            stopEnabled: true,
            nextEnabled: false,
            prevEnabled: false),
      );
      states = RadioStates.Success;
    } catch (audioException) {
      states = RadioStates.Error;
    }
    notifyListeners();
  }
}
