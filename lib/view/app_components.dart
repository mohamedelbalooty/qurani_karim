import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';

AppBar buildDefaultAppBar({@required String title}) => AppBar(
      automaticallyImplyLeading: true,
      title: Text(
        title,
        style: const TextStyle(color: whiteColor),
      ),
    );

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
          gradient:
              context.select<AppThemeProvider, bool>((value) => value.isDark)
                  ? darkGradient()
                  : lightGradient(),
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
        overlayColor: MaterialStateProperty.all(
          Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Text(
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

BuildDefaultIconButton copyButton(BuildContext context,
        {@required String textValue}) =>
    BuildDefaultIconButton(
      icon: Icons.copy,
      onClick: () => copyText(context, textValue: textValue),
    );

BuildDefaultIconButton shareButton({@required String textValue}) =>
    BuildDefaultIconButton(
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
    return Selector<AppThemeProvider, bool>(
      selector: (context, provider) => provider.isDark,
      builder: (context, value, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => value
              ? const LinearGradient(colors: [whiteColor, whiteColor])
                  .createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                )
              : lightGradient().createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
          child: Text(
            text,
            style: style,
            textAlign: textAlign,
          ),
        );
      },
    );
  }
}

class GradientIcon extends StatelessWidget {
  const GradientIcon({
    Key key,
    @required this.icon,
    @required this.size,
  }) : super(key: key);

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Selector<AppThemeProvider, bool>(
      selector: (context, provider) => provider.isDark,
      builder: (context, value, child) {
        return ShaderMask(
          child: SizedBox(
            width: size * 1.2,
            height: size * 1.2,
            child: Icon(
              icon,
              size: size,
              color: Colors.white,
            ),
          ),
          shaderCallback: (Rect bounds) {
            final Rect rect = Rect.fromLTRB(0, 0, size, size);
            return value
                ? const LinearGradient(colors: [whiteColor, whiteColor])
                    .createShader(rect)
                : lightGradient().createShader(rect);
          },
        );
      },
    );
  }
}

class BuildLoadingWidget extends StatelessWidget {
  const BuildLoadingWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (Platform.isAndroid)
          ? CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            )
          : CupertinoActivityIndicator(),
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

LinearGradient lightGradient() => const LinearGradient(
    colors: [Colors.purple, Colors.indigo],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft);

LinearGradient darkGradient() =>
    const LinearGradient(colors: [mainDarkColor, mainDarkColor]);

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
