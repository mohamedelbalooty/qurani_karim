import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';
import '../app_components.dart';

class BuildCustomDivider extends StatelessWidget {
  const BuildCustomDivider({Key? key, required this.margin}) : super(key: key);
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
  const BuildVersionWidget({Key? key}) : super(key: key);

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
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GradientText(
                    ' ${snapshot.data?.version}',
                    style: TextStyle(
                      color: mainColor,
                      fontSize: 24.sp,
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
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GradientText(
                  ' 1.0.0',
                  style: TextStyle(
                    color: mainColor,
                    fontSize: 24.sp,
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
      {Key? key,
      required this.title,
      required this.icon,
      required this.onClick,
      this.isThemeToggle = false})
      : super(key: key);
  final String title;
  final IconData icon;
  final VoidCallback onClick;
  final bool isThemeToggle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding2(),
      child: InkWell(
        onTap: onClick,
        child: Row(
          children: [
            GradientIcon(
              icon: icon,
              size: 24.sp,
            ),
            horizontalSpace4(),
            GradientText(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            !isThemeToggle
                ? GradientIcon(
                    icon: Icons.arrow_forward_ios,
                    size: 20.sp,
                  )
                : GradientIcon(
                    icon: context.select<AppThemeProvider, bool>(
                            (value) => value.isDark)
                        ? Icons.brightness_4_outlined
                        : Icons.brightness_4,
                    size: 24.sp,
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
      onClick: () {
        showModalBottomSheet(
            context: context,
            backgroundColor: transparent,
            shape: const OutlineInputBorder(
                borderSide: BorderSide(color: transparent),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                )),
            builder: (_) {
              return Selector<AppThemeProvider, bool>(
                selector: (context, provider) => provider.isDark,
                builder: (context, value, child) {
                  return Container(
                    height: 250.h,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 5.0),
                    margin: const EdgeInsets.symmetric(horizontal: 30.0),
                    decoration: BoxDecoration(
                      color: value ? mainDarkColor : whiteColor,
                      borderRadius: const BorderRadiusDirectional.only(
                        topEnd: Radius.circular(20.0),
                        topStart: Radius.circular(20.0),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 60.0, vertical: 5.0),
                            child: Divider(
                              thickness: 3,
                              color: mainColor,
                            ),
                          ),
                          GradientText(
                            'about_app'.tr(),
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                height: 2),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      },
    ),
    BuildDrawerItemWidget(
      title: 'privacy'.tr(),
      icon: Icons.lock_outline,
      onClick: () => launchURL(
          'https://github.com/mohamedelbalooty/Qurani_Privacy_Policy/blob/main/README.md'),
    ),
    BuildDrawerItemWidget(
      title: 'share_app'.tr(),
      icon: Icons.share,
      onClick: () => shareText(textValue: 'https://play.google.com/store/apps/details?id=com.mohamedElbalooty.qurani_karim'),
    ),
    BuildDrawerItemWidget(
      title: 'ratting_app'.tr(),
      icon: Icons.shop,
      onClick: () => StoreRedirect.redirect(),
    ),
    BuildDrawerItemWidget(
      title: 'dark_mode'.tr(),
      icon: Icons.wb_sunny_outlined,
      isThemeToggle: true,
      onClick: () => context.read<AppThemeProvider>().changeAppTheme(),
    )
  ];
}

void launchURL(String url) async {
  if (!await launch(url)) throw 'Could not launch';
}
