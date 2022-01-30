import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/model/hadith.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

class BuildSearchWidget extends StatelessWidget {
  final Widget suffixIcon;
  final TextEditingController controller;
  final Function onChanged;

  const BuildSearchWidget(
      {Key key,
      @required this.controller,
      @required this.suffixIcon,
      @required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius(),
        gradient: defaultGradient(),
        border: Border.all(color: whiteColor, width: 1.5),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            offset: Offset(0.5, 0.5),
            spreadRadius: 1.5,
            blurRadius: 4,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: whiteColor,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyText1,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          hintText: 'search'.tr(),
          hintStyle: Theme.of(context).textTheme.bodyText1,
          suffixIcon: suffixIcon,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class BuildHadithItemWidget extends StatelessWidget {
  final Hadith hadith;

  const BuildHadithItemWidget({Key key, @required this.hadith})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius(),
        gradient: defaultGradient(),
        border: Border.all(color: whiteColor, width: 1.5),
        boxShadow: [
          const BoxShadow(
            color: Colors.black26,
            offset: Offset(0.5, 0.5),
            spreadRadius: 1.5,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Text(
              hadith.hadith,
              style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontWeight: FontWeight.bold, fontSize: 18.0, height: 1.8),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Text(
                hadith.reference,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              copyButton(context, textValue: hadith.hadith),
              shareButton(textValue: hadith.hadith),
            ],
          ),
        ],
      ),
    );
  }
}
