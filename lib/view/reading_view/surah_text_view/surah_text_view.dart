import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/ui_provider/change_font_size_provider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../../app_components.dart';

class SurahTextView extends StatelessWidget {
  final Surah surah;

  const SurahTextView({Key key, @required this.surah}) : super(key: key);


  // https://api.flutter.dev/flutter/widgets/RichText-class.html
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(title: surah.name),
      body: ElasticInUp(
        child: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: surah.ayahs.length + 2,
          itemBuilder: (_, index) {
            return index == 0
                ?  Consumer<ChangeFontSizeProvider>(
              builder: (context, provider, child) {
                return Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.center,
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    BuildDefaultGradientButton(
                      height: 40.0,
                      width: 100.0,
                      child: Center(
                        child: Text('increase_font'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(
                                fontWeight:
                                FontWeight.bold)),
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
                                .copyWith(
                                fontWeight:
                                FontWeight.bold)),
                      ),
                      onClick: () {
                        provider.decreaseFontSize();
                      },
                    ),
                  ],
                );
              },
            )
                : index == 1
                    ? Padding(
              padding:
              const EdgeInsets.only(top: 30.0, bottom: 15.0),
              child: GradientText(
                'besm_allah'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(
                  color: mainColor,
                ),
                textAlign: TextAlign.center,
              ),
            )
                    : GradientText(
                        '${surah.ayahs[index - 3].text}(${surah.ayahs[index - 3].numberInSurah})',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: mainColor,
                          fontWeight: FontWeight.bold,
                          height: 2.0,
                        ),
                        textAlign: TextAlign.center,
                      );
          },
        ),
      ),
    );
  }
}
