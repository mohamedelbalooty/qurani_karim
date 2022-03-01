import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/cache_keys.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/utils/helper/cache_helper.dart';
import 'package:qurany_karim/view/ahadith_view/ahadith_view.dart';
import 'package:qurany_karim/view/askar_view/azkar_view.dart';
import 'package:qurany_karim/view/assmaa_allah_view/assmaa_allah_view.dart';
import 'package:qurany_karim/view/listening_view/listening_view.dart';
import 'package:qurany_karim/view/live_view/live_view.dart';
import 'package:qurany_karim/view/prayer_times_view/prayer_times_view.dart';
import 'package:qurany_karim/view/qiplah_view/qiplah_view.dart';
import 'package:qurany_karim/view/radio_view/radio_view.dart';
import 'package:qurany_karim/view/reading_view/reading_view.dart';
import 'package:qurany_karim/view/reading_view/surah_text_view/surah_text_view.dart';
import 'package:qurany_karim/view/tasbih_view/tasbih_view.dart';
import 'package:qurany_karim/view_model/ahadith/ahadith_view_model.dart';
import 'package:qurany_karim/view_model/assmaa_allah/assmaa_allah_view_model.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import 'package:qurany_karim/view_model/quran/states.dart';
import '../app_components.dart';
import 'package:provider/provider.dart';

AppBar buildAppBar() => AppBar(
      // backgroundColor: context,
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
            color: whiteColor),
      ),
      centerTitle: true,
    );

List<BuildGridCategoryItem> portraitGridWidgets(BuildContext context,
    {bool isPortrait}) {
  return [
    BuildGridCategoryItem(
        title: 'read_moshaf'.tr(),
        icon: 'assets/icons/quran.png',
        onClick: () {
          context.read<QuranViewModel>().getLocalData();
          namedNavigator(context, ReadingView.id);
        }),
    BuildGridCategoryItem(
        title: 'listen_moshaf'.tr(),
        icon: 'assets/icons/mic.png',
        onClick: () {
          namedNavigator(context, ListeningView.id);
        }),
    BuildGridCategoryItem(
        title: 'hades'.tr(),
        icon: 'assets/icons/prays.png',
        onClick: () {
          context.read<AhadithViewModel>().getAhadith(context);
          namedNavigator(context, AhadithView.id);
        }),
    BuildGridCategoryItem(
        title: 'azkar'.tr(),
        icon: 'assets/icons/azkar.png',
        onClick: () {
          namedNavigator(context, AzkarView.id);
        }),
  ];
}

List<BuildGridCategoryItem> landScapeGridWidgets(BuildContext context,
    {bool isPortrait}) {
  return [
    BuildGridCategoryItem(
        title: 'read_moshaf'.tr(),
        icon: 'assets/icons/quran.png',
        onClick: () {
          context.read<QuranViewModel>().getLocalData();
          namedNavigator(context, ReadingView.id);
        }),
    BuildGridCategoryItem(
        title: 'listen_moshaf'.tr(),
        icon: 'assets/icons/mic.png',
        onClick: () {
          namedNavigator(context, ListeningView.id);
        }),
    BuildGridCategoryItem(
        title: 'hades'.tr(),
        icon: 'assets/icons/prays.png',
        onClick: () {
          context.read<AhadithViewModel>().getAhadith(context);
          namedNavigator(context, AhadithView.id);
        }),
    BuildGridCategoryItem(
        title: 'azkar'.tr(),
        icon: 'assets/icons/azkar.png',
        onClick: () {
          namedNavigator(context, AzkarView.id);
        }),
    BuildGridCategoryItem(
        title: 'asmaa_allah'.tr(),
        icon: 'assets/icons/asmaa_allah.png',
        onClick: () {
          context.read<AssmaaAllahViewModel>().getAssmaaAllahAlhosna(context);
          namedNavigator(context, AssmaaAllahView.id);
        }),
    BuildGridCategoryItem(
        title: 'tasbeh'.tr(),
        icon: 'assets/icons/tasbih.png',
        onClick: () {
          namedNavigator(context, TasbihView.id);
        }),
  ];
}

List<BuildListCategoryItem> portraitListWidgets(BuildContext context,
    {bool isPortrait}) {
  return [
    BuildListCategoryItem(
        title: 'asmaa_allah'.tr(),
        icon: 'assets/icons/asmaa_allah.png',
        onClick: () {
          context.read<AssmaaAllahViewModel>().getAssmaaAllahAlhosna(context);
          namedNavigator(context, AssmaaAllahView.id);
        }),
    BuildListCategoryItem(
        title: 'tasbeh'.tr(),
        icon: 'assets/icons/tasbih.png',
        onClick: () {
          namedNavigator(context, TasbihView.id);
        }),
    BuildListCategoryItem(
        title: 'kebla'.tr(),
        icon: 'assets/icons/kaaba.png',
        onClick: () {
          namedNavigator(context, QiplahView.id);
        }),
    BuildListCategoryItem(
        title: 'times'.tr(),
        icon: 'assets/icons/time-zone.png',
        onClick: () {
          namedNavigator(context, PrayerTimesView.id);
        }),
    BuildListCategoryItem(
        title: 'radio'.tr(),
        icon: 'assets/icons/radio.png',
        onClick: () {
          namedNavigator(context, RadioView.id);
        }),
    BuildListCategoryItem(
        title: 'live'.tr(),
        icon: 'assets/icons/live.png',
        onClick: () {
          namedNavigator(context, LiveView.id);
        }),
  ];
}

List<BuildListCategoryItem> landScapeListWidgets(BuildContext context,
    {bool isPortrait}) {
  return [
    BuildListCategoryItem(
        title: 'kebla'.tr(),
        icon: 'assets/icons/kaaba.png',
        onClick: () {
          namedNavigator(context, QiplahView.id);
        }),
    BuildListCategoryItem(
        title: 'times'.tr(),
        icon: 'assets/icons/time-zone.png',
        onClick: () {
          namedNavigator(context, PrayerTimesView.id);
        }),
    BuildListCategoryItem(
        title: 'radio'.tr(),
        icon: 'assets/icons/radio.png',
        onClick: () {
          namedNavigator(context, RadioView.id);
        }),
    BuildListCategoryItem(
        title: 'live'.tr(),
        icon: 'assets/icons/live.png',
        onClick: () {
          namedNavigator(context, LiveView.id);
        }),
  ];
}

class BuildHomeCoverWidget extends StatelessWidget {
  const BuildHomeCoverWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.0,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.purple.shade400.withOpacity(0.4),
          Colors.indigoAccent.shade400.withOpacity(0.4)
        ], begin: Alignment.topRight, end: Alignment.bottomLeft),
        borderRadius: defaultBorderRadius(),
        border: Border.all(color: whiteColor, width: 1.5),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            offset: Offset(0.5, 0.5),
            spreadRadius: 1.5,
            blurRadius: 4,
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
                end: 5.0, top: 10.0, bottom: 5.0, start: 120.0),
            child: Image.asset(
              'assets/images/cover.png',
              fit: BoxFit.fill,
              width: double.infinity,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: 40.0,
              width: 150.0,
              margin: EdgeInsetsDirectional.only(start: 10.0, top: 45.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.purple.shade400.withOpacity(0.8),
                  Colors.indigoAccent.shade400.withOpacity(0.8),
                ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                borderRadius: const BorderRadius.all(
                  Radius.circular(10.0),
                ),
                boxShadow: [
                  const BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.5, 0.5),
                    spreadRadius: 1.5,
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'home_title'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BuildListCategoryItem extends StatelessWidget {
  final String title, icon;
  final Function onClick;

  const BuildListCategoryItem(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildDefaultGradientButton(
      height: 80.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              height: 60.0,
              width: 60.0,
              fit: BoxFit.fill,
            ),
            minimumHorizontalSpace(),
            Text(
              title,
              style: Theme.of(context).textTheme.headline2,
            ),
            const Spacer(),
            Text(
              'go'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontWeight: FontWeight.bold, height: 1.6),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: whiteColor,
              size: 18.0,
            ),
          ],
        ),
      ),
      onClick: onClick,
    );
  }
}

class BuildGridCategoryItem extends StatelessWidget {
  final String title, icon;
  final Function onClick;

  const BuildGridCategoryItem(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildDefaultGradientButton(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              icon,
              height: 70.0,
              width: 70.0,
              fit: BoxFit.fill,
            ),
            mediumVerticalSpace(),
            Hero(
              tag: title,
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  'go'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold, height: 1.6),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: whiteColor,
                  size: 18.0,
                ),
              ],
            ),
          ],
        ),
      ),
      onClick: onClick,
    );
  }
}
