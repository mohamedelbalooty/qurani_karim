import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
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
          gradient: defaultGradient(),
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
          // mainAxisAlignment: MainAxisAlignment.center,
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
