import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import 'package:qurany_karim/view_model/radio/radio_view_model.dart';
import 'package:qurany_karim/view_model/radio/states.dart';
import '../../utils/helper/size_configuration_helper.dart';
import '../app_components.dart';

class RadioView extends StatefulWidget {
  const RadioView({Key? key}) : super(key: key);
  static const String id = 'RadioView';

  @override
  _RadioViewState createState() => _RadioViewState();
}

class _RadioViewState extends State<RadioView> {
  final AssetsAudioPlayer _player = AssetsAudioPlayer();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<RadioViewModel>().playRadio(_player);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        SizeConfigurationHelper.screenOrientation == Orientation.portrait;
    return Container(
      decoration: BoxDecoration(
        gradient:
            context.select<AppThemeProvider, bool>((value) => value.isDark)
                ? darkGradient()
                : lightGradient(),
      ),
      child: Scaffold(
        backgroundColor: transparent,
        appBar: buildDefaultAppBar(title: 'radio'.tr()),
        body: Consumer<RadioViewModel>(
          builder: (context, provider, child) {
            if (provider.states == RadioStates.Initial) {
              return const BuildLoadingWidget();
            } else if (provider.states == RadioStates.Loading) {
              return const BuildLoadingWidget();
            } else if (provider.states == RadioStates.Success) {
              return FadeInRight(
                child: Center(
                  child: Image.asset(
                    'assets/icons/radio.png',
                    height: isPortrait ? 250.h : 150.h,
                    width: isPortrait ? 220.w : 120.w,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            } else {
              return BuildErrorWidget(
                errorResult: ErrorResult(
                    errorMessage: 'error'.tr(),
                    errorImage: 'assets/icons/no-internet.png'),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
