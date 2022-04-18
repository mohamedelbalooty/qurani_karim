import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import '../app_components.dart';

class BuildAlertDialogWidget extends StatelessWidget {
  final String text;

  const BuildAlertDialogWidget({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: padding2(),
      actions: [
        BuildDefaultTextButton(
          text: 'cancel'.tr(),
          buttonColor: Theme.of(context).primaryColor,
          onClick: () {
            popNavigate(context);
          },
        ),
      ],
      shape: OutlineInputBorder(
        borderRadius: defaultBorderRadius(),
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
      ),
      content: Selector<AppThemeProvider, bool>(
        selector: (context, provider) => provider.isDark,
        builder: (context, value, child) {
          return ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => value
                ? const LinearGradient(colors: [mainDarkColor, mainDarkColor])
                    .createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  )
                : lightGradient().createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
            child: Text(
              text,
              style:
                  Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
