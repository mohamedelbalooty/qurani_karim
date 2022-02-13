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

class BuildWelcomeButton extends StatelessWidget {
  final double height, width, radius;
  final Color color;
  final String title;
  final Function onClick;

  const BuildWelcomeButton(
      {Key key,
        @required this.title,
        @required this.onClick,
        this.height = 50.0,
        this.width = double.infinity,
        this.color = whiteColor,
        this.radius = 25.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(1.5, 1.5),
                blurRadius: 2,
                spreadRadius: 2),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline2.copyWith(color: mainColor),
          ),
        ),
      ),
    );
  }
}
