import 'package:after_layout/after_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
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
              if (provider.localDataStates ==
                  QuranGetLocalDataStates.Loading) {
                return BuildLoadingWidget();
              } else if (provider.localDataStates ==
                  QuranGetLocalDataStates.Loaded) {
                return ListView.separated(
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
                          context
                              .read<AudioViewModel>()
                              .isPlayingChanging();
                          context
                              .read<AudioViewModel>()
                              .selectSurahId(provider.quranData[index]);
                          context.read<AudioViewModel>().getSurahAudio(
                              surahId: provider.quranData[index].number,
                              elderFormat: widget.elder.identifier);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (_, index) => minimumVerticalSpace(),
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
              return provider.isPlaying
                  ? Container(
                          height: 90.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: provider.isPlaying ? mainColor : transparent,
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
                              provider.audioDataStates == AudioDataStates.Loading ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  children: [
                                    LinearProgressIndicator(),
                                    mediumVerticalSpace(),
                                  ],
                                ),
                              ) :Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BuildAudioButton(
                                    icon: Icons.skip_next,
                                    onClick: () {},
                                  ),
                                  mediumHorizontalSpace(),
                                  BuildAudioButton(
                                    icon: Icons.play_arrow,
                                    buttonSize: 12.0,
                                    iconSize: 26.0,
                                    onClick: () {},
                                  ),
                                  mediumHorizontalSpace(),
                                  BuildAudioButton(
                                    icon: Icons.skip_previous,
                                    onClick: () {},
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

class BuildAudioButton extends StatelessWidget {
  final double buttonSize, iconSize;
  final IconData icon;
  final Function onClick;

  const BuildAudioButton(
      {Key key,
      @required this.icon,
      @required this.onClick,
      this.buttonSize = 8.0,
      this.iconSize = 24.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(buttonSize),
        decoration: BoxDecoration(
          color: transparent,
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: whiteColor),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: whiteColor,
        ),
      ),
    );
  }
}
