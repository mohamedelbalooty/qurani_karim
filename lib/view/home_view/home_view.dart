import 'package:flutter/material.dart';
import 'package:qurany_karim/view/drawer_view/drawer_view.dart';
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
      drawer: DrawerView(),
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
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
    );
  }
}
