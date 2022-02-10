import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/view/app_components.dart';
import 'components.dart';
import 'package:provider/provider.dart';

class QiplahView extends StatelessWidget {
  QiplahView({Key key}) : super(key: key);
  static const String id = 'QiplahView';

  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            context.select<AppThemeProvider, bool>((value) => value.isDark)
                ? darkGradient()
                : lightGradient(),
      ),
      child: Scaffold(
        backgroundColor: transparent,
        appBar: buildDefaultAppBar(title: 'kebla'.tr()),
        body: FutureBuilder(
          future: _deviceSupport,
          builder: (_, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return BuildLoadingWidget();
            if (snapshot.hasError)
              return Center(
                child: Text(
                  "Error: ${snapshot.error.toString()}",
                  style: Theme.of(context).textTheme.headline2,
                ),
              );
            if (snapshot.data)
              return Center(
                child: QiblahCompass(),
              );
            else
              return LocationErrorWidget(
                callback: () {},
              );
          },
        ),
      ),
    );
  }
}
