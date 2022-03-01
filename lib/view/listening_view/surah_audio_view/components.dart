import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../../app_components.dart';

class BuildSurahAudioItemWidget extends StatelessWidget {
  final String name;
  final Function onClick;

  const BuildSurahAudioItemWidget(
      {Key key, @required this.name, @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 80.0,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          gradient:
              context.select<AppThemeProvider, bool>((value) => value.isDark)
                  ? darkGradient()
                  : lightGradient(),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              offset: Offset(0.5, 0.5),
              spreadRadius: 1.5,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/mic.png',
              height: 40.0,
              width: 40.0,
              fit: BoxFit.fill,
            ),
            minimumHorizontalSpace(),
            Expanded(
              child: Text(
                name,
                style:
                    Theme.of(context).textTheme.headline2.copyWith(height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildAudioButton extends StatelessWidget {
  final double buttonSize, iconSize;
  final Color buttonColor;
  final IconData icon;
  final Function onClick;

  const BuildAudioButton(
      {Key key,
      @required this.icon,
      @required this.onClick,
      this.buttonSize = 3.0,
      this.buttonColor = whiteColor,
      this.iconSize = 26.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(buttonSize),
        decoration: BoxDecoration(
          color: transparent,
          shape: BoxShape.circle,
          border: Border.all(width: 2.5, color: buttonColor),
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: buttonColor,
        ),
      ),
    );
  }
}

class BuildAudioLoading extends StatelessWidget {
  const BuildAudioLoading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          mediumVerticalSpace(),
        ],
      ),
    );
  }
}
