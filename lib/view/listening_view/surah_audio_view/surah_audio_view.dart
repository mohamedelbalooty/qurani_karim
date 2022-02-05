import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/elder.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/view_model/audio/audio_view_model.dart';
import 'package:qurany_karim/view_model/audio/states.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import 'package:qurany_karim/view_model/quran/states.dart';
import '../../app_components.dart';
import 'components.dart';

class SurahAudioView extends StatefulWidget {
  final Elder elder;

  const SurahAudioView({Key key, @required this.elder}) : super(key: key);

  @override
  _SurahAudioViewState createState() => _SurahAudioViewState();
}

class _SurahAudioViewState extends State<SurahAudioView> with AfterLayoutMixin {
  QuranViewModel _quranViewModel;
  AudioViewModel _audioViewModel;

  @override
  void afterFirstLayout(BuildContext context) {
    _quranViewModel = Provider.of<QuranViewModel>(context, listen: false);
    _audioViewModel = Provider.of<AudioViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(widget.elder.name),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Consumer<QuranViewModel>(
            builder: (context, provider, child) {
              if (provider.localDataStates == QuranGetLocalDataStates.Loading) {
                return BuildLoadingWidget();
              } else if (provider.localDataStates ==
                  QuranGetLocalDataStates.Loaded) {
                context
                    .read<AudioViewModel>()
                    .initializeQuranData(provider.quranData);
                return ElasticInUp(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    physics: const BouncingScrollPhysics(),
                    itemCount: provider.quranData.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: index == provider.quranData.length - 1
                            ? EdgeInsets.only(bottom: 95.0)
                            : EdgeInsets.zero,
                        child: BuildSurahAudioItemWidget(
                          name: provider.quranData[index].name,
                          onClick: () {
                            context.read<AudioViewModel>().isOpenedAudio();
                            context.read<AudioViewModel>().selectSurah(
                                id: provider.quranData[index].number,
                                elderFormat: widget.elder.identifier);
                            if (context
                                    .watch<AudioViewModel>()
                                    .audioDataStates ==
                                AudioDataStates.Error) {
                              showToast(context,
                                  toastValue: context
                                      .watch<AudioViewModel>()
                                      .error
                                      .errorMessage);
                            }
                          },
                        ),
                      );
                    },
                    separatorBuilder: (_, index) => minimumVerticalSpace(),
                  ),
                );
              } else {
                return BuildErrorWidget(
                  errorResult: provider.error,
                );
              }
            },
          ),
          Consumer<AudioViewModel>(
            builder: (context, provider, child) {
              return provider.openedAudio
                  ? Container(
                      height: 90.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: provider.openedAudio ? mainColor : transparent,
                        borderRadius: BorderRadiusDirectional.only(
                          topEnd: Radius.circular(20.0),
                          topStart: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            provider.surah.name,
                            style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: whiteColor,
                                height: 2),
                          ),
                          const Spacer(),
                          provider.audioDataStates == AudioDataStates.Loading
                              ? BuildAudioLoading()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    BuildAudioButton(
                                      icon: Icons.skip_next,
                                      buttonColor: provider.surah.number == 114
                                          ? Colors.grey.shade400
                                          : whiteColor,
                                      onClick: provider.surah.number == 114
                                          ? () {}
                                          : () async {
                                              await provider.selectSurah(
                                                  id: provider.surah.number + 1,
                                                  elderFormat:
                                                      widget.elder.identifier);
                                            },
                                    ),
                                    mediumHorizontalSpace(),
                                    BuildAudioButton(
                                      icon: !provider.isPlaying
                                          ? Icons.play_arrow
                                          : Icons.pause,
                                      buttonSize: 7.0,
                                      iconSize: 36.0,
                                      onClick: () {
                                        provider.playState == PlayState.Ended ||
                                                provider.playState ==
                                                    PlayState.Initial
                                            ? provider.playSurahAudio()
                                            : provider.pauseAudio();
                                      },
                                    ),
                                    mediumHorizontalSpace(),
                                    BuildAudioButton(
                                      icon: Icons.skip_previous,
                                      buttonColor: provider.surah.number == 1
                                          ? Colors.grey.shade400
                                          : whiteColor,
                                      onClick: provider.surah.number == 1
                                          ? () {}
                                          : () async {
                                              await provider.selectSurah(
                                                  id: provider.surah.number - 1,
                                                  elderFormat:
                                                      widget.elder.identifier);
                                            },
                                    ),
                                  ],
                                ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    )
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _quranViewModel.disposeData();
    _audioViewModel.disposeData();
    super.dispose();
  }
}
