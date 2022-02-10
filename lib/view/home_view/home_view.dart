import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/utils/constants/cache_keys.dart';
import 'package:qurany_karim/utils/helper/cache_helper.dart';
import 'package:qurany_karim/view/drawer_view/drawer_view.dart';
import 'package:qurany_karim/view/reading_view/surah_text_view/surah_text_view.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import 'package:qurany_karim/view_model/quran/states.dart';
import '../app_components.dart';
import 'components.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  static const String id = 'HomeView';

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      drawer: DrawerView(),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 5.0),
            child: Consumer<QuranViewModel>(
              builder: (context, provider, child) {
                return CacheHelper.getIntData(key: isCachingSurahText) != null
                    ? InkWell(
                        onTap: () {
                          provider.getSurahData().then((value) {
                            if (provider.cachedSurahDataStates ==
                                QuranGetCachedSurahDataStates.Loaded) {
                              materialNavigator(context,
                                  SurahTextView(surah: provider.cachedSurah));
                            } else {
                              showToast(context,
                                  toastValue: provider.error.errorMessage);
                            }
                          });
                        },
                        child: Image.asset(
                          'assets/icons/drawer_logo.png',
                        ),
                      )
                    : const SizedBox();
              },
            ),
          )
        ],
        title: Text(
          'qurany_karim'.tr(),
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'ReemKufi',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            minimumVerticalSpace(),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isPortrait
                  ? portraitGridWidgets(context).length
                  : landScapeGridWidgets(context).length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 2 : 3,
                childAspectRatio: isPortrait ? 0.85 : 1.2,
              ),
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: isPortrait
                      ? portraitGridWidgets(context,
                          isPortrait: isPortrait)[index]
                      : landScapeGridWidgets(context,
                          isPortrait: isPortrait)[index],
                );
              },
            ),
            ListView.separated(
              padding: const EdgeInsets.all(10.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: isPortrait
                  ? portraitListWidgets(context).length
                  : landScapeListWidgets(context).length,
              itemBuilder: (_, index) {
                return isPortrait
                    ? portraitListWidgets(context,
                        isPortrait: isPortrait)[index]
                    : landScapeListWidgets(context,
                        isPortrait: isPortrait)[index];
              },
              separatorBuilder: (_, index) => minimumVerticalSpace(),
            )
          ],
        ),
      ),
    );
  }
}
