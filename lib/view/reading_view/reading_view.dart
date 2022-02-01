import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../app_components.dart';
import 'surah_text_view/surah_text_view.dart';

class ReadingView extends StatelessWidget {
  const ReadingView({Key key}) : super(key: key);

  static const String id = 'ReadingView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('read_moshaf'.tr()),
      ),
      body: FadeInRight(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          physics: const BouncingScrollPhysics(),
          itemCount: 13,
          itemBuilder: (_, index) {
            return BuildSurahWidgetItem(
              surahName: 'البقرة',
              surahNumber: 4.toString(),
              isListen: false,
              onClick: () {
                materialNavigator(
                  context,
                  SurahTextView(
                    appBarTitle: 'البقرة',
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
