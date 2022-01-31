import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/ui_provider/tasbih_provider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import '../app_components.dart';

class TasbihView extends StatelessWidget {
  const TasbihView({Key key}) : super(key: key);
  static const String id = 'TasbihView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Hero(
          tag: 'tasbeh'.tr(),
          child: Text('tasbeh'.tr()),
        ),
      ),
      body: Consumer<TasbihProvider>(
        builder: (context, provider, child) {
          return FadeInRight(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    minimumVerticalSpace(),
                    BuildDefaultGradientButton(
                      height: 60.0,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.selectedValue,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              size: 28.0,
                              color: whiteColor,
                            ),
                          ],
                        ),
                      ),
                      onTapUp: (TapUpDetails details) {
                        double dx = details.globalPosition.dx;
                        double dy = details.globalPosition.dy;
                        double dx2 = MediaQuery.of(context).size.width - dx;
                        double dy2 = MediaQuery.of(context).size.width - dy;
                        showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(dx, dy, dx2, dy2),
                            color: mainColor,
                            shape: OutlineInputBorder(
                              borderRadius: defaultBorderRadius(),
                              borderSide: BorderSide(color: whiteColor, width: 1.5),
                            ),
                            items: provider.tasbihData
                                .map(
                                  (e) => PopupMenuItem(
                                    value: e,
                                    child: InkWell(
                                      child: Text(e),
                                      onTap: () {
                                        provider.selectCurrentValue(value: e);
                                        provider.reset();
                                        popNavigate(context);
                                      },
                                    ),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            fontWeight: FontWeight.bold, height: 2),
                                  ),
                                )
                                .toList());
                      },
                    ),
                    mediumVerticalSpace(),
                    GradientText(
                      provider.selectedValue,
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: mainColor, fontSize: 28.0),
                    ),
                    mediumVerticalSpace(),
                    GradientText(
                      provider.tasbihNumber.toString(),
                      style: const TextStyle(
                        fontSize: 45.0,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    minimumVerticalSpace(),
                    GradientText(
                      'tasbih_number'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(color: mainColor, fontSize: 28.0),
                    ),
                    const SizedBox(height: 5),
                    BuildDefaultTextButton(
                      text: 'reset'.tr(),
                      fontSize: 22.0,
                      onClick: () {
                        provider.reset();
                      },
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    InkWell(
                      borderRadius: defaultBorderRadius(),
                      splashColor: mainColor.withOpacity(0.3),
                      highlightColor: mainColor.withOpacity(0.3),
                      hoverColor: mainColor.withOpacity(0.2),
                      onTap: () {
                        provider.tasbih();
                      },
                      child: Image.asset(
                        'assets/icons/figerprint.png',
                        height: 140.0,
                        width: 140.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
