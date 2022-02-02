import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
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
      body: Consumer<QuranViewModel>(
        builder: (context, provider, child) {
          return FadeInRight(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              physics: const BouncingScrollPhysics(),
              itemCount: provider.quranData.length,
              itemBuilder: (_, index) {
                return BuildSurahWidgetItem(
                  surahName: provider.quranData[index].name ?? '',
                  surahNumber: provider.quranData[index].number.toString(),
                  isListen: false,
                  onClick: () {
                    materialNavigator(
                      context,
                      SurahTextView(
                        surah: provider.quranData[index],
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (_, index) => minimumVerticalSpace(),
            ),
          );
        },
      ),
    );
  }
}
