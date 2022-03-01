import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

class BuildSurahItemWidget extends StatelessWidget {
  final Surah surah;
  final String surahType;
  final Function onClick;

  const BuildSurahItemWidget(
      {Key key,
      @required this.surah,
      @required this.surahType,
      @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 80.0,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          gradient:
              context.select<AppThemeProvider, bool>((value) => value.isDark)
                  ? darkGradient()
                  : lightGradient(),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              offset: Offset(0.5, 0.5),
              spreadRadius: 1.5,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.brightness_5,
                  size: 60,
                  color: whiteColor,
                ),
                Text(
                  surah.number.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold, height: 1.6),
                ),
              ],
            ),
            minimumHorizontalSpace(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  surah.name,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  '${surah.ayahs.length} ${'ayah'.tr()} - $surahType',
                  style: const TextStyle(
                      color: whiteColor,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'go'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold, height: 1.6),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: whiteColor,
                  size: 18.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
