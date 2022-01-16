import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'utils/helper/dio_helper.dart';
import 'view/single_views/welcome_view.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeView.id,
      routes: {
        WelcomeView.id: (_) => WelcomeView(),
      },
      localizationsDelegates: translator.delegates,
      locale: translator.activeLocale,
      supportedLocales: translator.locals(),
      theme: ThemeData(
        primaryColor: mainColor,
        fontFamily: 'Tajawal',
        scaffoldBackgroundColor: whiteColor,
        textTheme: TextTheme(
          headline1: TextStyle(
            color: whiteColor,
            fontSize: 38.0,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            color: whiteColor,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
            color: whiteColor,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
          bodyText2: TextStyle(
            color: whiteColor,
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
