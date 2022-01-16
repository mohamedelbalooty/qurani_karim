import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

class WelcomeView extends StatelessWidget {
  static const String id = 'WelcomeView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                bigVerticalSpace(),
                Text(
                  'your_life'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(color: mainColor),
                ),
                minimumVerticalSpace(),
                Text(
                  'beauty_our_sound'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .copyWith(color: mainColor),
                ),
                bigVerticalSpace(),
                SizedBox(
                  height: 425.0,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Container(
                        height: 400.0,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'read_question'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2.copyWith(fontSize: 24.0,height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                              minimumVerticalSpace(),
                              Text(
                                'read_answer'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline2.copyWith(fontSize: 20.0,height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60.0),
                          child: BuildDefaultButton(
                            title: 'start_reading'.tr(),
                            onClick: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
