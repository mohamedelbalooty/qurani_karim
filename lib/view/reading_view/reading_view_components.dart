import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

class BuildSurahWidgetItem extends StatelessWidget {
  final String surahName, surahNumber;
  final Function onClick;

  const BuildSurahWidgetItem(
      {@required this.surahName,
      @required this.surahNumber,
      @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 80.0,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          gradient: defaultGradient(),
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
                  surahNumber,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold, height: 1.6),
                ),
              ],
            ),
            minimumHorizontalSpace(),
            Text(
              surahName,
              style:
                  Theme.of(context).textTheme.headline2.copyWith(height: 1.6),
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
