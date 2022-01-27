import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../../app_components.dart';

class SurahAudioView extends StatelessWidget {
  final String id, name;

  const SurahAudioView({Key key, @required this.id, @required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('listen_moshaf'.tr()),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        physics: const BouncingScrollPhysics(),
        itemCount: 13,
        itemBuilder: (_, index) {
          return BuildSurahWidgetItem(
            surahName: 'البقرة',
            surahNumber: 4.toString(),
            isListen: true,
            onClick: () {
              // materialNavigator(
              //   context,
              //   SurahView(
              //     appBarTitle: 'البقرة',
              //   ),
              // );
            },
          );
        },
        separatorBuilder: (_, index) => minimumVerticalSpace(),
      ),
      bottomNavigationBar: BottomAppBar(
        color: mainColor,
        elevation: 5.0,
        child: Container(
          height: AppBar().preferredSize.height,
          width: double.infinity,
          color: mainColor,
          child: Row(
            children: [

            ],
          ),
        ),
      ),
    );
  }
}
