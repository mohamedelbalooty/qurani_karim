import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_components.dart';

class BuildCustomDivider extends StatelessWidget {
  const BuildCustomDivider({Key key, @required this.margin}) : super(key: key);
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.5,
      margin: margin,
      decoration: BoxDecoration(
        gradient:
            context.select<AppThemeProvider, bool>((value) => value.isDark)
                ? darkGradient()
                : lightGradient(),
      ),
    );
  }
}

class BuildVersionWidget extends StatelessWidget {
  const BuildVersionWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GradientText(
                    'version'.tr(),
                    style: const TextStyle(
                      color: mainColor,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GradientText(
                    ' ${snapshot.data.version}',
                    style: const TextStyle(
                      color: mainColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          default:
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GradientText(
                  'version'.tr(),
                  style: const TextStyle(
                    color: mainColor,
                    fontSize: 26.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GradientText(
                  ' 1.0.0',
                  style: const TextStyle(
                    color: mainColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
        }
      },
    );
  }
}

class BuildDrawerItemWidget extends StatelessWidget {
  const BuildDrawerItemWidget(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.onClick,
      this.isThemeToggle = false})
      : super(key: key);
  final String title;
  final IconData icon;
  final Function onClick;
  final bool isThemeToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onClick,
        child: Row(
          children: [
            GradientIcon(
              icon: icon,
              size: 24.0,
            ),
            mediumHorizontalSpace(),
            GradientText(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            !isThemeToggle
                ? GradientIcon(
                    icon: Icons.arrow_forward_ios,
                    size: 20.0,
                  )
                : GradientIcon(
                    icon: context.select<AppThemeProvider, bool>(
                            (value) => value.isDark)
                        ? Icons.brightness_4_outlined
                        : Icons.brightness_4,
                    size: 24.0,
                  ),
          ],
        ),
      ),
    );
  }
}

List<Widget> drawerItems(BuildContext context) {
  return [
    BuildDrawerItemWidget(
      title: 'about'.tr(),
      icon: Icons.help_outline,
      onClick: () {},
    ),
    BuildDrawerItemWidget(
      title: 'privacy'.tr(),
      icon: Icons.lock_outline,
      onClick: () {},
    ),
    BuildDrawerItemWidget(
      title: 'contact_us'.tr(),
      icon: Icons.email_outlined,
      onClick: () {
        launchURL(
            'mailto:mohamedelbalooty123@gmail.com?%20subject&%20body');
      },
    ),
    BuildDrawerItemWidget(
      title: 'dark_mode'.tr(),
      icon: Icons.wb_sunny_outlined,
      isThemeToggle: true,
      onClick: () {
        context.read<AppThemeProvider>().changeAppTheme();
      },
    )
  ];
}

void launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch';
}

ThemeData lightTheme() => ThemeData(
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
    );

ThemeData darkTheme() => ThemeData(
      primaryColor: mainDarkColor,
      primarySwatch: Colors.purple,
      fontFamily: 'Tajawal',
      scaffoldBackgroundColor: secondDarkColor,
      appBarTheme: AppBarTheme(
        titleTextStyle: const TextStyle(
          color: mainDarkColor,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      textTheme: TextTheme(
        headline1: const TextStyle(
          color: mainDarkColor,
          fontSize: 38.0,
          fontWeight: FontWeight.bold,
        ),
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
    );
