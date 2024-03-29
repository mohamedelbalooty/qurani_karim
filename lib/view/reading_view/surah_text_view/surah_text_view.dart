import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/ui_provider/change_font_size_provider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import 'package:qurany_karim/view_model/quran/quran_view_model.dart';
import '../../app_components.dart';
import 'components.dart';

class SurahTextView extends StatefulWidget {
  final Surah surah;

  const SurahTextView({Key? key, required this.surah}) : super(key: key);

  @override
  _SurahTextViewState createState() => _SurahTextViewState();
}

class _SurahTextViewState extends State<SurahTextView> with AfterLayoutMixin {
  late QuranViewModel _quranViewModel;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<QuranViewModel>().cachingSurah(surahId: widget.surah.number);
    });
    super.initState();
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _quranViewModel = Provider.of<QuranViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(title: widget.surah.name),
      body: ElasticInUp(
        child: ListView(
          padding: symmetricHorizontalPadding1(),
          children: [
            verticalSpace5(),
            GradientText(
              'besm_allah'.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpace2(),
            Selector<ChangeFontSizeProvider, int>(
              selector: (context, provider) => provider.fontSize,
              builder: (context, value, child) {
                return SelectableText.rich(
                  TextSpan(
                    children: widget.surah.ayahs
                        .map(
                          (e) => TextSpan(
                            text: '${e.text} (${e.numberInSurah}) ',
                            style: TextStyle(
                              fontSize: value.toDouble(),
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Tajawal',
                              foreground: Paint()
                                ..shader = context.select<AppThemeProvider,
                                        bool>((value) => value.isDark)
                                    ? const LinearGradient(
                                            colors: [whiteColor, whiteColor])
                                        .createShader(
                                        const Rect.fromLTWH(
                                            0.0, 220.0, 220.0, 0.0),
                                      )
                                    : lightGradient().createShader(
                                        const Rect.fromLTWH(
                                            0.0, 220.0, 220.0, 0.0),
                                      ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: transparent,
        elevation: 5.0,
        child: Container(
          height: 65.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color:
                context.select<AppThemeProvider, bool>((value) => value.isDark)
                    ? mainDarkColor
                    : mainColor,
            borderRadius: const BorderRadiusDirectional.only(
              topEnd: Radius.circular(20.0),
              topStart: Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding: symmetricHorizontalPadding1(),
            child: Consumer<ChangeFontSizeProvider>(
              builder: (context, provider, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BuildCircleButton(
                      symbol: '＋',
                      onClick: () => provider.increaseFontSize(),
                    ),
                    Text(
                      'font_size'.tr(),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    BuildCircleButton(
                      symbol: '－',
                      onClick: () => provider.decreaseFontSize(),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _quranViewModel.getSurahData();
    super.dispose();
  }
}
