import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../app_components.dart';
import 'components.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  static const String id = 'HomeView';

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'qurany_karim'.tr(),
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w500,
            fontFamily: 'ReemKufi',
          ),
        ),
        centerTitle: true,
      ),
      body: FlipInY(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              minimumVerticalSpace(),
              BuildHomeCoverWidget(),
              minimumVerticalSpace(),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: isPortrait
                    ? portraitGridWidgets(context).length
                    : landScapeGridWidgets(context).length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isPortrait ? 2 : 3,
                  childAspectRatio: isPortrait ? 0.85 : 1.2,
                ),
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: isPortrait
                        ? portraitGridWidgets(context,
                            isPortrait: isPortrait)[index]
                        : landScapeGridWidgets(context,
                            isPortrait: isPortrait)[index],
                  );
                },
              ),
              // const SizedBox(height: 5),
              ListView.separated(
                padding: const EdgeInsets.all(10.0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: isPortrait
                    ? portraitListWidgets(context).length
                    : landScapeListWidgets(context).length,
                itemBuilder: (_, index) {
                  return isPortrait
                      ? portraitListWidgets(context,
                          isPortrait: isPortrait)[index]
                      : landScapeListWidgets(context,
                          isPortrait: isPortrait)[index];
                },
                separatorBuilder: (_, index) => minimumVerticalSpace(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
