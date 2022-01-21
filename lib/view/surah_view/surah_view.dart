import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/change_font_size.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

class SurahView extends StatelessWidget {
  final String appBarTitle;

  const SurahView({@required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(title: 'البقرة'),
      body: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          Consumer<ChangeFontSizeProvider>(
            builder: (context, provider, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BuildTextButton(
                    title: 'increase_font'.tr(),
                    icon: Icons.add,
                    onClick: () {
                      provider.increaseFontSize();
                    },
                  ),
                  BuildTextButton(
                    title: 'decrease_font'.tr(),
                    icon: Icons.minimize_sharp,
                    onClick: () {
                      provider.decreaseFontSize();
                    },
                  ),
                ],
              );
            },
          ),
          bigVerticalSpace(),
          Text(
            'besm_allah'.tr(),
            style: Theme.of(context).textTheme.headline2.copyWith(color: mainColor,),
            textAlign: TextAlign.center,
          ),
          mediumVerticalSpace(),
          Text(
            "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (1)الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ (2) الرَّحْمَنِ الرَّحِيمِ (3) مَالِكِ يَوْمِ الدِّينِ (4) إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ (5) اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ (6) صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ (7)",
            style: TextStyle(
              fontSize: (context.select<ChangeFontSizeProvider, int>(
                  (value) => value.fontSize)).toDouble(),
              color: mainColor,
              fontWeight: FontWeight.bold,
              height: 2.0
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class BuildTextButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function onClick;

  const BuildTextButton(
      {@required this.title, @required this.icon, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 40.0,
        width: 110.0,
        decoration: BoxDecoration(color: mainColor, borderRadius: defaultBorderRadius(),),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              icon,
              size: 18.0,
              color: whiteColor,
            ),

            Text(
              title,
              style: const TextStyle(color: whiteColor, fontWeight: FontWeight.bold, fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}
