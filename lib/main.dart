import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qurany_karim/model/ayah.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/utils/routes.dart';
import 'ui_provider/app_theme_povider.dart';
import 'utils/constants/cache_keys.dart';
import 'utils/helper/cache_helper.dart';
import 'utils/helper/dio_helper.dart';
import 'utils/providers.dart';
import 'view/drawer_view/components.dart';
import 'view/home_view/home_view.dart';
import 'view/single_views/welcome_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await translator.init(
    language: 'ar',
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
  );
  await Hive.initFlutter();
  Hive.registerAdapter(SurahAdapter());
  Hive.registerAdapter(AyahAdapter());
  DioHelper.init();
  CacheHelper.init();
  runApp(
    LocalizedApp(
      child: MultiProvider(
        providers: Providers.providers,
        child: QuranyKarim(),
      ),
    ),
  );
}

class QuranyKarim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
        headerBuilder: () => WaterDropHeader(),
        footerBuilder: () => ClassicFooter(),
        headerTriggerDistance: 30.0,
        springDescription:
            SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        maxOverScrollExtent: 30,
        maxUnderScrollExtent: 0,
        enableScrollWhenRefreshCompleted: true,
        enableLoadingWhenFailed: true,
        hideFooterWhenNotFull: false,
        enableBallisticLoad: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Qurani Karim - قراّني كريم',
          initialRoute: CacheHelper.getBooleanData(key: isCachingQuran) == null
              ? WelcomeView.id
              : HomeView.id,
          routes: Routes.routes,
          localizationsDelegates: translator.delegates,
          locale: translator.activeLocale,
          supportedLocales: translator.locals(),
          theme: lightTheme(),
          darkTheme: darkTheme(),
          themeMode:
              context.select<AppThemeProvider, bool>((value) => value.isDark)
                  ? ThemeMode.dark
                  : ThemeMode.light,
        ));
  }
}
