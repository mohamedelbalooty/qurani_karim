import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import 'package:qurany_karim/view/qiplah_view/components.dart';
import 'package:qurany_karim/view_model/prayer_times/prayer_times_view_model.dart';
import 'package:qurany_karim/view_model/prayer_times/states.dart';
import '../app_components.dart';
import 'components.dart';

class PrayerTimesView extends StatelessWidget {
  const PrayerTimesView({super.key});
  static const String id = 'PrayerTimesView';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            context.select<AppThemeProvider, bool>((value) => value.isDark)
                ? darkGradient()
                : lightGradient(),
      ),
      child: Scaffold(
        backgroundColor: transparent,
        appBar: buildDefaultAppBar(title: 'times'.tr()),
        body: Consumer<PrayerTimesViewModel>(
          builder: (context, provider, child) {
            if (provider.states == PrayerTimesStates.Initial) {
              provider.determinePosition();
              return const BuildLoadingWidget();
            } else if (provider.states == PrayerTimesStates.Loading) {
              return const BuildLoadingWidget();
            } else if (provider.states == PrayerTimesStates.Success) {
              return PrayerTimesCompass(
                prayerTimes: provider.prayerTimes,
              );
            } else {
              return LocationErrorWidget(
                error: 'enable_location'.tr(),
                callback: provider.determinePosition,
              );
            }
          },
        ),
      ),
    );
  }
}
