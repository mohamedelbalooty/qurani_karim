import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../app_components.dart';
import 'components.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key key}) : super(key: key);

  static const String id = 'HomeView';

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  AnimationController controller() {
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    return _controller;
  }

  Animation<double> animation() {
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    return _animation;
  }

  // var counter = 0;
  // int repeatTimes = 10; // how many times you want to repeat animation
  //
  // _controller.addStatusListener((status) {
  // if (status == AnimationStatus.completed) {
  // if (++counter < repeatTimes) {
  // animation.reverse();
  // }
  // } else if (status == AnimationStatus.dismissed) {
  // animation.forward();
  // }
  // });

  var counter = 1;
  int repeatTimes = 12;

  @override
  void initState() {
    super.initState();
    controller();
    animation();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.stop();
      } else {
        _controller.forward();
      }
    });
    // TickerFuture tickerFuture = _controller.repeat();
    // tickerFuture.timeout(Duration(seconds: 3), onTimeout:  () {
    //   _controller.forward(from: 0);
    //   _controller.stop(canceled: true);
    // });
  }
  // ScaleTransition

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
      body: SingleChildScrollView(
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
                      ? portraitGridWidgets(context, isPortrait: isPortrait)[index]
                      : landScapeGridWidgets(context, isPortrait: isPortrait)[index],
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
                    ? portraitListWidgets(context, isPortrait: isPortrait)[index]
                    : landScapeListWidgets(context, isPortrait: isPortrait)[index];
              },
              separatorBuilder: (_, index) => minimumVerticalSpace(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
