import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import 'package:qurany_karim/view_model/quran/states.dart';
import '../app_components.dart';
import 'components.dart';
import 'surah_text_view/surah_text_view.dart';

class ReadingView extends StatefulWidget {
  const ReadingView({Key key}) : super(key: key);

  static const String id = 'ReadingView';

  @override
  _ReadingViewState createState() => _ReadingViewState();
}

class _ReadingViewState extends State<ReadingView> with AfterLayoutMixin {
  QuranViewModel _quranViewModel;

  @override
  void afterFirstLayout(BuildContext context) {
    _quranViewModel = Provider.of<QuranViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('read_moshaf'.tr()),
      ),
      body: Consumer<QuranViewModel>(
        builder: (context, provider, child) {
          if (provider.localDataStates == QuranGetLocalDataStates.Loading) {
            return BuildLoadingWidget();
          } else if (provider.localDataStates ==
              QuranGetLocalDataStates.Loaded) {
            return FadeInRight(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                physics: const BouncingScrollPhysics(),
                itemCount: provider.quranData.length,
                itemBuilder: (_, index) {
                  return BuildSurahItemWidget(
                    surah: provider.quranData[index],
                    surahType:
                        provider.quranData[index].revelationType == 'Meccan'
                            ? 'meccan'.tr()
                            : 'medinan'.tr(),
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
          } else {
            return BuildErrorWidget(
              errorResult: provider.error,
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _quranViewModel.disposeData();
    super.dispose();
  }
}
