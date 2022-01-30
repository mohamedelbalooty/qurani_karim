import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';

class BuildSurahWidgetItem extends StatelessWidget {
  final String surahName, surahNumber;
  final bool isListen;
  final Function onClick;

  const BuildSurahWidgetItem(
      {Key key,
      @required this.surahName,
      @required this.surahNumber,
      @required this.isListen,
      @required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        height: 80.0,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          gradient: defaultGradient(),
          boxShadow: [
            const BoxShadow(
              color: Colors.black12,
              offset: Offset(0.5, 0.5),
              spreadRadius: 1.5,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.brightness_5,
                  size: 60,
                  color: whiteColor,
                ),
                Text(
                  surahNumber,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold, height: 1.6),
                ),
              ],
            ),
            minimumHorizontalSpace(),
            Text(
              surahName,
              style:
                  Theme.of(context).textTheme.headline2.copyWith(height: 1.6),
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  isListen ? 'listen'.tr() : 'go'.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(fontWeight: FontWeight.bold, height: 1.6),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: whiteColor,
                  size: 18.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

AppBar buildDefaultAppBar({@required String title}) => AppBar(
      automaticallyImplyLeading: true,
      title: Text(title),
    );

class BuildDefaultButton extends StatelessWidget {
  final double height, width, radius;
  final Color color;
  final String title;
  final Function onClick;

  const BuildDefaultButton(Key key,
      {@required this.title,
      @required this.onClick,
      this.height = 50.0,
      this.width = double.infinity,
      this.color = thirdColor,
      this.radius = 25.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                offset: Offset(1.5, 1.5),
                blurRadius: 2,
                spreadRadius: 2),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
    );
  }
}

class BuildDefaultGradientButton extends StatelessWidget {
  final double height, width;
  final Widget child;
  final Function onClick, onTapUp;

  const BuildDefaultGradientButton(
      {Key key,
      @required this.child,
      this.onClick,
      this.onTapUp,
      this.height = 100.0,
      this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      onTapUp: onTapUp,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: defaultGradient(),
          borderRadius: defaultBorderRadius(),
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
        child: child,
      ),
    );
  }
}

class BuildDefaultIconButton extends StatelessWidget {
  final IconData icon;
  final Function onClick;
  final Color color;

  const BuildDefaultIconButton(
      {Key key,
      @required this.icon,
      @required this.onClick,
      this.color = whiteColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: 26.0,
        color: color,
      ),
      onPressed: onClick,
    );
  }
}

class BuildDefaultTextButton extends StatelessWidget {
  final Function onClick;
  final String text;
  final double fontSize;
  final Color buttonColor;

  const BuildDefaultTextButton({
    Key key,
    @required this.text,
    @required this.onClick,
    this.fontSize = 16.0,
    this.buttonColor = mainColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(mainColor.withOpacity(0.3))),
      child: GradientText(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: buttonColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: onClick,
    );
  }
}

BuildDefaultIconButton copyButton(BuildContext context, {@required String textValue}) => BuildDefaultIconButton(
  icon: Icons.copy,
  onClick: () => copyText(context, textValue: textValue),
);

BuildDefaultIconButton shareButton({@required String textValue}) => BuildDefaultIconButton(
  icon: Icons.share,
  onClick: () => shareText(textValue: textValue),
);

class GradientText extends StatelessWidget {
  const GradientText(this.text, {this.style, this.textAlign});

  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => defaultGradient().createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
      ),
    );
  }
}

class BuildLoadingWidget extends StatelessWidget {
  const BuildLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class BuildErrorWidget extends StatelessWidget {
  final ErrorResult errorResult;

  const BuildErrorWidget({Key key, @required this.errorResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 220.0,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        color: transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              errorResult.errorImage,
              height: 150.0,
              width: 150.0,
              fit: BoxFit.fill,
            ),
            Container(
              // height: 50.0,
              width: double.infinity,
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: defaultBorderRadius(),
              ),
              child: Center(
                child: Text(
                  errorResult.errorMessage,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

BorderRadius defaultBorderRadius() => const BorderRadius.all(
      Radius.circular(10.0),
    );

LinearGradient defaultGradient() => LinearGradient(
    colors: [Colors.purple.shade400, Colors.indigoAccent.shade400],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft);

SizedBox bigVerticalSpace() => const SizedBox(height: 30);

SizedBox mediumVerticalSpace() => const SizedBox(height: 20);

SizedBox minimumVerticalSpace() => const SizedBox(height: 10);

SizedBox mediumHorizontalSpace() => const SizedBox(width: 20);

SizedBox minimumHorizontalSpace() => const SizedBox(width: 10);

void showToast(BuildContext context, {@required String toastValue}) {
  Toast.show(toastValue, context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
}

Future<void> copyText(BuildContext context,
    {@required String textValue}) async {
  await Clipboard.setData(ClipboardData(text: textValue));
  showToast(context, toastValue: 'copy_text'.tr());
}

Future<void> shareText({@required String textValue}) async {
  await Share.share(textValue);
}

void namedNavigator(BuildContext context, String routeName) =>
    Navigator.pushNamed(context, routeName);

void replacementNamedNavigator(BuildContext context, String routeName) =>
    Navigator.pushReplacementNamed(context, routeName);

void materialNavigator(BuildContext context, Widget screen) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );

void popNavigate(BuildContext context) => Navigator.pop(context);
