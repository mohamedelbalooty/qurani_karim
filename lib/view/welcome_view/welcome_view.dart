import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import 'package:qurany_karim/view/home_view/home_view.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import 'package:qurany_karim/view_model/quran/states.dart';
import '../app_components.dart';
import 'components.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});
  static const String id = 'WelcomeView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElasticInUp(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  verticalSpace5(),
                  Text(
                    'qurany_karim'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .headline1!
                        .copyWith(color: mainColor, fontFamily: 'ReemKufi'),
                  ),
                  verticalSpace2(),
                  Text(
                    'beauty_our_sound'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .headline2!
                        .copyWith(color: mainColor),
                  ),
                  verticalSpace5(),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 25.h, horizontal: 10.w),
                            decoration: const BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.all(
                                Radius.circular(25.0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30.w),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'read_question'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(fontSize: 24.sp, height: 1.3),
                                    textAlign: TextAlign.center,
                                  ),
                                  verticalSpace2(),
                                  Text(
                                    'read_answer'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline2!
                                        .copyWith(fontSize: 20.sp, height: 1.6),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 25.h),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.w),
                        child: Consumer<QuranViewModel>(
                          builder: (context, provider, child) {
                            return BuildWelcomeButton(
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
                                  showToast(
                                      toastValue: provider.error!.errorMessage);
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
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
