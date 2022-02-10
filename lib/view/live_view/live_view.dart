import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/model/youtube_channel.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/view/app_components.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';

class LiveView extends StatelessWidget {
  const LiveView({Key key}) : super(key: key);
  static const String id = 'LiveView';

  @override
  Widget build(BuildContext context) {
    final List<YoutubeChannel> channels = [
      YoutubeChannel(
          name: 'قناة القران الكريم السعودية مباشر',
          url: 'https://youtu.be/e-q8FKdEKaU'),
      YoutubeChannel(
          name: 'قناة السنة النبوية', url: 'https://youtu.be/KPSKRKyyoOw'),
    ];

    return Scaffold(
      appBar: buildDefaultAppBar(title: 'live'.tr()),
      body: FadeInRight(
        child: ListView.separated(
          padding: const EdgeInsets.all(10.0),
          itemCount: channels.length,
          itemBuilder: (_, index) {
            return Selector<AppThemeProvider, bool>(
              selector: (context, provider) => provider.isDark,
              builder: (context, value, child) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: value ? darkGradient() : lightGradient(),
                    borderRadius: defaultBorderRadius(),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: transparent,
                          borderRadius: defaultBorderRadius(),
                          border: Border.all(
                            color: whiteColor,
                            width: 1.5,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: defaultBorderRadius(),
                          child: YoutubePlayer(
                            controller: YoutubePlayerController(
                              initialVideoId:
                                  convertVideoUrl(channels[index].url),
                              flags: const YoutubePlayerFlags(
                                  autoPlay: false,
                                  isLive: true,
                                  enableCaption: true),
                            ),
                            showVideoProgressIndicator: true,
                          ),
                        ),
                      ),
                      minimumVerticalSpace(),
                      Text(
                        '  ${channels[index].name}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      minimumVerticalSpace(),
                    ],
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

  String convertVideoUrl(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }
}
