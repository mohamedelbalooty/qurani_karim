import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/youtube_channel.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import 'package:qurany_karim/view/app_components.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LiveView extends StatefulWidget {
  const LiveView({super.key});
  static const String id = 'LiveView';

  @override
  State<LiveView> createState() => _LiveViewState();
}

class _LiveViewState extends State<LiveView> {
  late YoutubePlayerController _youtubePlayerController;
  final List<YoutubeChannel> _channels = const [
    YoutubeChannel(
      name: ' مكة المكرمة بث مباشر | قناة القرآن الكريم',
      url: 'https://youtu.be/h4LV2viNHmk',
    ),
    YoutubeChannel(
      name: ' بث مباشر || قناة السنة النبوية',
      url: 'https://youtu.be/gUC3TjCrwRw',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(title: 'live'.tr()),
      body: FadeInRight(
        child: ListView.separated(
          padding: padding2(),
          itemCount: _channels.length,
          itemBuilder: (_, index) {
            _youtubePlayerController = YoutubePlayerController(
              initialVideoId: _convertVideoUrl(_channels[index].url)!,
              flags: const YoutubePlayerFlags(
                autoPlay: false,
                isLive: true,
                enableCaption: true,
              ),
            );
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
                        height: 220.h,
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
                            controller: _youtubePlayerController,
                            showVideoProgressIndicator: true,
                          ),
                        ),
                      ),
                      verticalSpace2(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            _channels[index].name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      verticalSpace2(),
                    ],
                  ),
                );
              },
            );
          },
          separatorBuilder: (_, index) => verticalSpace2(),
        ),
      ),
    );
  }

  String? _convertVideoUrl(String url) => YoutubePlayer.convertUrlToId(url);

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    super.dispose();
  }
}
