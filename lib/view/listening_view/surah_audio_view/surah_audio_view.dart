import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:qurany_karim/model/elder.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import 'package:qurany_karim/view_model/quran/states.dart';
import '../../app_components.dart';
import 'components.dart';

class SurahAudioView extends StatelessWidget {
  final Elder elder;

  const SurahAudioView({Key key, @required this.elder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(elder.name),
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
                  return BuildSurahAudioItemWidget(
                    name: provider.quranData[index].name,
                    onClick: () {},
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
      // bottomNavigationBar: BottomAppBar(
      //   color: mainColor,
      //   elevation: 5.0,
      //   child: Container(
      //     height: AppBar().preferredSize.height,
      //     width: double.infinity,
      //     color: mainColor,
      //     child: Row(
      //       children: [
      //
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
