import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:qurany_karim/ui_provider/change_font_size_provider.dart';
import 'package:qurany_karim/ui_provider/tasbih_provider.dart';
import 'package:qurany_karim/ui_provider/time_provider.dart';
import 'package:qurany_karim/ui_provider/toggle_provider.dart';
import 'package:qurany_karim/view_model/ahadith/ahadith_view_model.dart';
import 'package:qurany_karim/view_model/assmaa_allah/assmaa_allah_view_model.dart';
import 'package:qurany_karim/view_model/audio/audio_view_model.dart';
import 'package:qurany_karim/view_model/azkar/azkar_view_model.dart';
import 'package:qurany_karim/view_model/elders/elders_view_model.dart';
import 'package:qurany_karim/view_model/prayer_times/prayer_times_view_model.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import 'package:qurany_karim/view_model/radio/radio_view_model.dart';

class Providers {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider<ChangeFontSizeProvider>(
      create: (_) => ChangeFontSizeProvider(),
    ),
    ChangeNotifierProvider<TasbihProvider>(
      create: (_) => TasbihProvider(),
    ),
    ChangeNotifierProvider<AzkarViewModel>(
      create: (_) => AzkarViewModel(),
    ),
    ChangeNotifierProvider<AhadithViewModel>(
      create: (_) => AhadithViewModel(),
    ),
    ChangeNotifierProvider<AssmaaAllahViewModel>(
      create: (_) => AssmaaAllahViewModel(),
    ),
    ChangeNotifierProvider<ToggleProvider>(
      create: (_) => ToggleProvider(),
    ),
    ChangeNotifierProvider<QuranViewModel>(
      create: (_) => QuranViewModel(),
    ),
    ChangeNotifierProvider<EldersViewModel>(
      create: (_) => EldersViewModel(),
    ),
    ChangeNotifierProvider<AudioViewModel>(
      create: (_) => AudioViewModel(),
    ),
    ChangeNotifierProvider<TimeProvider>(
      create: (_) => TimeProvider(),
    ),
    ChangeNotifierProvider<PrayerTimesViewModel>(
      create: (_) => PrayerTimesViewModel(),
    ),
    ChangeNotifierProvider<RadioViewModel>(
      create: (_) => RadioViewModel(),
    ),
    // ChangeNotifierProvider<PrayerTimesViewModel>(
    //   create: (_) => PrayerTimesViewModel(),
    // ),ChangeNotifierProvider<PrayerTimesViewModel>(
    //   create: (_) => PrayerTimesViewModel(),
    // ),
  ];
}
