import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:share_plus/share_plus.dart';

import '../app_components.dart';

class AzkarDetailsView extends StatelessWidget {
  final int id;
  final String title;

  const AzkarDetailsView({Key key, @required this.id, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(title),
      ),
      body: ListView.separated(
        itemCount: 5,
        padding: const EdgeInsets.all(10.0),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: defaultBorderRadius(),
              gradient: defaultGradient(),
              border: Border.all(color: whiteColor, width: 1.5),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0.5, 0.5),
                  spreadRadius: 1.5,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                minimumVerticalSpace(),
                Row(
                  children: [
                    Container(
                      height: 30.0,
                      width: 60.0,
                      alignment: Alignment.topRight,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadiusDirectional.only(
                            topEnd: Radius.circular(10.0),
                            bottomEnd: Radius.circular(10.0)),
                      ),
                      child: Center(
                        child: Text(
                          '2 ${'many'.tr()}',
                          style: Theme.of(context).textTheme.bodyText2.copyWith(
                              fontWeight: FontWeight.bold, color: mainColor),
                        ),
                      ),
                    ),
                    const Spacer(),
                    BuildDefaultIconButton(
                      icon: Icons.copy,
                      onClick: () {
                        Clipboard.setData(ClipboardData(text: "your text"));
                        showToast(context, toastValue: 'copy_text'.tr());
                      },
                    ),
                    BuildDefaultIconButton(
                      icon: Icons.share,
                      onClick: () async {
                        await Share.share(
                            'من قالها حين يصبح وحين يمسى كفته من كل شىء (الإخلاص والمعوذتين)');
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: Text(
                    'بِسْمِ اللهِ الرَّحْمنِ الرَّحِيمقُلْ أَعُوذُ بِرَبِّ ٱلْفَلَقِ، مِن شَرِّ مَا خَلَقَ، وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ، وَمِن شَرِّ ٱلنَّفَّٰثَٰتِ فِى ٱلْعُقَدِ، وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ.',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        height: 1.8),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: Text(
                      'سورة الفلق',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                minimumVerticalSpace(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10.0),
                  decoration: const BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(10),
                        bottomStart: Radius.circular(10)),
                  ),
                  child: GradientText(
                    'من قالها حين يصبح وحين يمسى كفته من كل شىء (الإخلاص والمعوذتين).',
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.bold, height: 1.8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (_, index) => minimumVerticalSpace(),
      ),
    );
  }
}
