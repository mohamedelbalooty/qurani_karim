import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import '../../app_components.dart';

class BuildSurahAudioItemWidget extends StatelessWidget {
  final String name;
  final VoidCallback onClick;

  const BuildSurahAudioItemWidget(
      {super.key, required this.name, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 80.h,
        width: double.infinity,
        padding:  symmetricHorizontalPadding1(),
        decoration: BoxDecoration(
          gradient:
              context.select<AppThemeProvider, bool>((value) => value.isDark)
                  ? darkGradient()
                  : lightGradient(),
          boxShadow: const [
            BoxShadow(
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
              height: 40.r,
              width: 40.r,
              fit: BoxFit.fill,
            ),
            horizontalSpace2(),
            Expanded(
              child: Text(
                name,
                style: Theme.of(context)
                    .textTheme
                    .headline2!
                    .copyWith(height: 1.6),
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
  final VoidCallback onClick;

  const BuildAudioButton(
      {super.key,
      required this.icon,
      required this.onClick,
      this.buttonSize = 3.0,
      this.buttonColor = whiteColor,
      this.iconSize = 26.0});

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
  const BuildAudioLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: symmetricHorizontalPadding3(),
      child: Column(
        children: [
          LinearProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
          verticalSpace4(),
        ],
      ),
    );
  }
}
