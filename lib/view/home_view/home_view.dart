import 'package:flutter/material.dart';
import 'package:qurany_karim/view/drawer_view/drawer_view.dart';
import '../../utils/helper/size_configuration_helper.dart';
import 'components.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  static const String id = 'HomeView';

  @override
  Widget build(BuildContext context) {
    SizeConfigurationHelper.initSizeConfiguration(context);
    return Scaffold(
      drawer: const DrawerView(),
      appBar: buildAppBar(),
      body: LayoutBuilder(builder: (_, constraints) {
        if (SizeConfigurationHelper.screenOrientation == Orientation.portrait) {
          return const BuildHomePortraitLayout();
        } else {
          return const BuildHomeLandScapeLayout();
        }
      }),
    );
  }
}
