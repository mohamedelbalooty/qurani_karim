import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';

class BuildCircleButton extends StatelessWidget {
  final String symbol;
  final VoidCallback onClick;

  const BuildCircleButton(
      {Key? key, required this.symbol, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        symbol,
        style: TextStyle(
          fontSize: 30.sp,
          color: context.select<AppThemeProvider, bool>((value) => value.isDark)
              ? mainDarkColor
              : mainColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        backgroundColor: whiteColor,
        shadowColor: mainColor,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(2.0),
      ),
      onPressed: onClick,
    );
  }
}
