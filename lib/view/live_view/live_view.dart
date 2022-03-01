import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/youtube_channel.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/view/app_components.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveView extends StatelessWidget {
  const LiveView({Key key}) : super(key: key);
  static const String id = 'LiveView';

  @override
  Widget build(BuildContext context) {
    final List<YoutubeChannel> channels = const [
      YoutubeChannel(
        name: ' مكة المكرمة بث مباشر | قناة القرآن الكريم',
        url: 'https://youtu.be/NxSU6fcQmPs',
      ),
      YoutubeChannel(
        name: 'قناة السنة النبوية',
        url: 'https://youtu.be/4GCH7_Gj0ro',
      ),
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
                                  _convertVideoUrl(channels[index].url),
                              flags: const YoutubePlayerFlags(
                                autoPlay: false,
                                isLive: true,
                                enableCaption: true,
                              ),
                            ),
                            showVideoProgressIndicator: true,
                          ),
                        ),
                      ),
                      minimumVerticalSpace(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${channels[index].name}',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ],
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

  String _convertVideoUrl(String url) => YoutubePlayer.convertUrlToId(url);
}
