import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

void showLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: transparent,
          content: Container(
            height: 120.0,
            width: 150.0,
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: defaultBorderRadius(),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BuildLoadingWidget(),
                minimumVerticalSpace(),
                Text(
                  'fetch_data'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: mainColor),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      });
}
