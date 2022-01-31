import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/change_font_size_provider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../../app_components.dart';

class SurahTextView extends StatelessWidget {
  final String appBarTitle;

  const SurahTextView({Key key, @required this.appBarTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(title: 'البقرة'),
      body: ElasticInUp(
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            Consumer<ChangeFontSizeProvider>(
              builder: (context, provider, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BuildDefaultGradientButton(
                      height: 40.0,
                      width: 100.0,
                      child: Center(
                        child: Text('increase_font'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                      onClick: () {
                        provider.increaseFontSize();
                      },
                    ),
                    BuildDefaultGradientButton(
                      height: 40.0,
                      width: 100.0,
                      child: Center(
                        child: Text('decrease_font'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontWeight: FontWeight.bold)),
                      ),
                      onClick: () {
                        provider.decreaseFontSize();
                      },
                    ),
                  ],
                );
              },
            ),
            bigVerticalSpace(),
            Align(
              alignment: Alignment.center,
              child: GradientText(
                'besm_allah'.tr(),
                style: Theme.of(context).textTheme.headline2.copyWith(
                      color: mainColor,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
            minimumVerticalSpace(),
            GradientText(
              "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (1)الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ (2) الرَّحْمَنِ الرَّحِيمِ (3) مَالِكِ يَوْمِ الدِّينِ (4) إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ (5) اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ (6) صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ (7)",
              style: TextStyle(
                  fontSize: (context.select<ChangeFontSizeProvider, int>(
                      (value) => value.fontSize)).toDouble(),
                  color: mainColor,
                  fontWeight: FontWeight.bold,
                  height: 2.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
