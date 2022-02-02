import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/view/home_view/home_view.dart';
import 'package:qurany_karim/view/single_views/components.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import 'package:qurany_karim/view_model/quran/states.dart';
import '../app_components.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key key}) : super(key: key);
  static const String id = 'WelcomeView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElasticInUp(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  bigVerticalSpace(),
                  Text(
                    'your_life'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(color: mainColor, fontFamily: 'ReemKufi'),
                  ),
                  minimumVerticalSpace(),
                  Text(
                    'beauty_our_sound'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(color: mainColor),
                  ),
                  bigVerticalSpace(),
                  SizedBox(
                    height: 425.0,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Container(
                          height: 400.0,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: mainColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(25.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'read_question'.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(fontSize: 24.0, height: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                                minimumVerticalSpace(),
                                Text(
                                  'read_answer'.tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(fontSize: 20.0, height: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 60.0),
                            child: Consumer<QuranViewModel>(
                              builder: (context, provider, child) {
                                return BuildDefaultButton(
                                  title: 'start_reading'.tr(),
                                  onClick: () async {
                                    showLoading(context);
                                    await provider.getRemoteData();
                                    popNavigate(context);
                                    if (provider.remoteDataStates ==
                                        QuranGetRemoteDataStates.Loaded) {
                                      replacementNamedNavigator(
                                          context, HomeView.id);
                                    }
                                    if (provider.remoteDataStates ==
                                        QuranGetRemoteDataStates.Error) {
                                      showToast(context,
                                          toastValue:
                                              provider.error.errorMessage);
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
