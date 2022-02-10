import 'package:flutter/material.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import '../app_components.dart';
import 'components.dart';
import 'package:provider/provider.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180.0,
                width: double.infinity,
                padding: const EdgeInsets.only(top: 30.0),
                decoration: BoxDecoration(
                  gradient: context.select<AppThemeProvider, bool>(
                          (value) => value.isDark)
                      ? darkGradient()
                      : lightGradient(),
                ),
                child: Image.asset(
                  'assets/icons/drawer_logo.png',
                  height: 50.0,
                  width: 50.0,
                ),
              ),
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: drawerItems(context).length + 1,
                itemBuilder: (_, index) {
                  return index == 0
                      ? const BuildVersionWidget()
                      : drawerItems(context)[index - 1];
                },
                separatorBuilder: (_, index) => index != 0
                    ? BuildCustomDivider(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      )
                    : const SizedBox(),
              ),
              BuildCustomDivider(
                margin: const EdgeInsets.symmetric(
                    horizontal: 50.0, vertical: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
