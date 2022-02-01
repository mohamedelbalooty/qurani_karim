import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qurany_karim/ui_provider/change_font_size_provider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/view/askar_view/azkar_view.dart';
import 'package:qurany_karim/view/assmaa_allah_view/assmaa_allah_view.dart';
import 'package:qurany_karim/view_model/azkar/azkar_view_model.dart';
import 'ui_provider/tasbih_provider.dart';
import 'ui_provider/toggle_provider.dart';
import 'utils/helper/dio_helper.dart';
import 'view/ahadith_view/ahadith_view.dart';
import 'view/home_view/home_view.dart';

import 'view/listening_view/listening_view.dart';
import 'view/qiplah_view/qiplah_view.dart';
import 'view/reading_view/reading_view.dart';
import 'view/single_views/welcome_view.dart';
import 'view/tasbih_view/tasbih_view.dart';
import 'view_model/ahadith/ahadith_view_model.dart';
import 'view_model/assmaa_allah/assmaa_allah_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await translator.init(
    localeType: LocalizationDefaultType.device,
    languagesList: <String>['ar', 'en'],
    assetsDirectory: 'assets/langs/',
  );
  DioHelper.init();
  runApp(
    LocalizedApp(
      child: QuranyKarim(),
    ),
  );
}

class QuranyKarim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChangeFontSizeProvider>(
            create: (_) => ChangeFontSizeProvider()),
        ChangeNotifierProvider<TasbihProvider>(
            create: (_) => TasbihProvider()),
        ChangeNotifierProvider<AzkarViewModel>(
            create: (_) => AzkarViewModel()),
        ChangeNotifierProvider<AhadithViewModel>(
            create: (_) => AhadithViewModel()),
        ChangeNotifierProvider<AssmaaAllahViewModel>(
            create: (_) => AssmaaAllahViewModel()),
        ChangeNotifierProvider<ToggleProvider>(
            create: (_) => ToggleProvider()),
        // ChangeNotifierProvider<ChangeFontSizeProvider>(
        //     create: (_) => ChangeFontSizeProvider()),
        // ChangeNotifierProvider<ChangeFontSizeProvider>(
        //     create: (_) => ChangeFontSizeProvider()),
        // ChangeNotifierProvider<ChangeFontSizeProvider>(
        //     create: (_) => ChangeFontSizeProvider()),
        // ChangeNotifierProvider<ChangeFontSizeProvider>(
        //     create: (_) => ChangeFontSizeProvider()),
        // ChangeNotifierProvider<ChangeFontSizeProvider>(
        //     create: (_) => ChangeFontSizeProvider()),
      ],
      child: RefreshConfiguration(
        headerBuilder: () => WaterDropHeader(),
        footerBuilder:  () => ClassicFooter(),
        headerTriggerDistance: 80.0,
        springDescription: SpringDescription(stiffness: 170, damping: 16, mass: 1.9),
        maxOverScrollExtent :100,
        maxUnderScrollExtent:0,
        enableScrollWhenRefreshCompleted: true,
        enableLoadingWhenFailed : true,
        hideFooterWhenNotFull: false,
        enableBallisticLoad: true,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: HomeView.id,
          routes: {
            WelcomeView.id: (_) => WelcomeView(),
            HomeView.id: (_) => HomeView(),
            ReadingView.id: (_) => ReadingView(),
            TasbihView.id: (_) => TasbihView(),
            ListeningView.id: (_) => ListeningView(),
            AzkarView.id: (_) => AzkarView(),
            AhadithView.id: (_) => AhadithView(),
            AssmaaAllahView.id: (_) => AssmaaAllahView(),
            QiplahView.id: (_) => QiplahView(),
            // ReadingView.id: (_) => ReadingView(),
            // ReadingView.id: (_) => ReadingView(),
            // ReadingView.id: (_) => ReadingView(),
          },
          localizationsDelegates: translator.delegates,
          locale: translator.activeLocale,
          supportedLocales: translator.locals(),
          theme: ThemeData(
            primaryColor: mainColor,
            primarySwatch: Colors.purple,
            fontFamily: 'Tajawal',
            scaffoldBackgroundColor: Colors.grey.shade50,
            appBarTheme: AppBarTheme(
              titleTextStyle: const TextStyle(
                color: whiteColor,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
              centerTitle: true,
            ),
            textTheme: TextTheme(
              headline1: const TextStyle(
                color: whiteColor,
                fontSize: 38.0,
                fontWeight: FontWeight.bold,
              ),

              ///button
              headline2: const TextStyle(
                color: whiteColor,
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
              bodyText1: const TextStyle(
                color: whiteColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              bodyText2: const TextStyle(
                color: whiteColor,
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
