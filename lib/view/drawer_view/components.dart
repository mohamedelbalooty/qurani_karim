import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:package_info/package_info.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

class BuildVersionWidget extends StatelessWidget {
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
                  Text(
                    'version'.tr(),
                    style: const TextStyle(
                      color: mainColor,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
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
                Text(
                  'version'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: mainColor),
                ),
                Text(
                  '1.0.0',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: mainColor),
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
            Icon(
              icon,
              size: 24.0,
              color: mainColor,
            ),
            mediumHorizontalSpace(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            !isThemeToggle
                ? Icon(
                    Icons.arrow_forward_ios,
                    size: 20.0,
                    color: mainColor,
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class BuildContactInfoItemWidget extends StatelessWidget {
  const BuildContactInfoItemWidget(
      {Key key,
      @required this.title,
      @required this.icon,
      @required this.onClick})
      : super(key: key);
  final String title, icon;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: onClick,
        child: Row(
          children: [
            Image.asset(
              icon,
              height: 30.0,
              width: 30.0,
              fit: BoxFit.fill,
            ),
            mediumHorizontalSpace(),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                color: mainColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<BuildDrawerItemWidget> drawerItems() {
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
      title: 'dark_mode'.tr(),
      icon: Icons.brightness_4_outlined,
      isThemeToggle: true,
      onClick: () {},
    ),
  ];
}

List<BuildContactInfoItemWidget> contactInfoItems() {
  return [
    BuildContactInfoItemWidget(
      title: 'Gmail',
      icon: 'assets/icons/gmail.png',
      onClick: () {},
    ),
    BuildContactInfoItemWidget(
      title: 'Facebook',
      icon: 'assets/icons/facebook.png',
      onClick: () {},
    ),
    BuildContactInfoItemWidget(
      title: 'Linkedin',
      icon: 'assets/icons/linkedin.png',
      onClick: () {},
    ),
  ];
}
