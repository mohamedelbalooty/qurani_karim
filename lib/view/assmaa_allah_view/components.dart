import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

class BuildAlertDialogWidget extends StatelessWidget {
  final String text;

  const BuildAlertDialogWidget({Key key, @required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10.0),
      actions: [
        BuildDefaultTextButton(
          text: 'cancel'.tr(),
          onClick: () {
            popNavigate(context);
          },
        ),
      ],
      shape: OutlineInputBorder(
        borderRadius: defaultBorderRadius(),
        borderSide: BorderSide(color: mainColor, width: 2.0),
      ),
      content: GradientText(
        text,
        style: Theme.of(context).textTheme.bodyText1.copyWith(height: 1.5),
        textAlign: TextAlign.center,
      ),
    );
  }
}
