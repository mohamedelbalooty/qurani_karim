import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/view/surah_view/surah_view.dart';
import '../app_components.dart';
import 'reading_view_components.dart';

class ReadingView extends StatelessWidget {
  static const String id = 'ReadingView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Hero(
          tag: 'read_moshaf'.tr(),
          child: Text('read_moshaf'.tr()),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        physics: const BouncingScrollPhysics(),
        itemCount: 13,
        itemBuilder: (_, index) {
          return BuildSurahWidgetItem(surahName: 'البقرة', surahNumber: 4.toString(), onClick: (){
            materialNavigator(context, SurahView(appBarTitle: 'البقرة',));
          },);
        },
        separatorBuilder: (_, index) => minimumVerticalSpace(),
      ),
    );
  }
}

