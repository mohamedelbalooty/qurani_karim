import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';
import 'components.dart';

class DrawerView extends StatelessWidget {
  const DrawerView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180.0,
              width: double.infinity,
              padding: const EdgeInsets.only(top: 30.0),
              decoration: BoxDecoration(
                gradient: defaultGradient(),
              ),
              child: Image.asset(
                'assets/icons/drawer_logo.png',
                height: 50.0,
                width: 50.0,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: drawerItems().length + 1,
                      itemBuilder: (_, index) {
                        return index == 0
                            ? BuildVersionWidget()
                            : drawerItems()[index-1];
                      },
                      separatorBuilder: (_, index) => index != 0
                          ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Divider(
                                thickness: 1.5,
                                color: mainColor,
                              ),
                          )
                          : const SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
                      child: Divider(
                        thickness: 1.5,
                        color: mainColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'contact_us'.tr(),
                        style: const TextStyle(
                          color: mainColor,
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    minimumVerticalSpace(),
                    ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: contactInfoItems().length,
                      itemBuilder: (_, index) => contactInfoItems()[index],
                      separatorBuilder: (_, index) => const SizedBox(height: 5,),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

