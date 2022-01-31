import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';
import 'surah_audio_view/surah_audio_view.dart';

class ListeningView extends StatelessWidget {
  const ListeningView({Key key}) : super(key: key);
  static const String id = 'ListeningView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Hero(
          tag: 'listen_moshaf'.tr(),
          child: Text('listen_moshaf'.tr()),
        ),
      ),
      body: FadeInRight(
        child: ListView.separated(
          padding: const EdgeInsets.all(10.0),
          physics: const BouncingScrollPhysics(),
          itemCount: 13,
          itemBuilder: (_, index) {
            return BuildDefaultGradientButton(
              key: key,
              height: 60.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.music_note,
                      size: 26.0,
                      color: whiteColor,
                    ),
                    Expanded(
                      child: Text(
                        'محمد صديق المنشاوي',
                        style: Theme.of(context).textTheme.headline2,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              onClick: () {
                materialNavigator(
                  context,
                  SurahAudioView(
                    key: key,
                    id: '',
                    name: '',
                  ),
                );
              },
            );
          },
          separatorBuilder: (_, index) => minimumVerticalSpace(),
        ),
      ),
    );
  }
}
