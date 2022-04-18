import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import '../app_components.dart';
import 'components.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key}) : super(key: key);

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
                height: 180.h,
                width: double.infinity,
                padding: EdgeInsets.only(top: 30.h),
                decoration: BoxDecoration(
                  gradient: context.select<AppThemeProvider, bool>(
                          (value) => value.isDark)
                      ? darkGradient()
                      : lightGradient(),
                ),
                child: Image.asset(
                  'assets/icons/drawer_logo.png',
                  height: 50.w,
                  width: 50.w,
                ),
              ),
              ListView.separated(
                padding: symmetricHorizontalPadding1(),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: drawerItems(context).length + 1,
                itemBuilder: (_, index) {
                  return index == 0
                      ? const BuildVersionWidget()
                      : drawerItems(context)[index - 1];
                },
                separatorBuilder: (_, index) => index != 0
                    ? const BuildCustomDivider(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                      )
                    : const SizedBox(),
              ),
              const BuildCustomDivider(
                margin: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
