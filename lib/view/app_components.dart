import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/helper/size_configuration_helper.dart';

SizedBox verticalSpace0() => SizedBox(height: 3.h);

SizedBox verticalSpace1() => SizedBox(height: 5.h);

SizedBox verticalSpace2() => SizedBox(height: 10.h);

SizedBox verticalSpace3() => SizedBox(height: 15.h);

SizedBox verticalSpace4() => SizedBox(height: 20.h);

SizedBox verticalSpace5() => SizedBox(height: 30.h);

SizedBox horizontalSpace0() => SizedBox(width: 2.w);

SizedBox horizontalSpace1() => SizedBox(width: 5.w);

SizedBox horizontalSpace2() => SizedBox(width: 10.w);

SizedBox horizontalSpace3() => SizedBox(width: 15.w);

SizedBox horizontalSpace4() => SizedBox(width: 20.w);

SizedBox horizontalSpace5() => SizedBox(width: 30.w);

EdgeInsets padding1() => const EdgeInsets.all(5);

EdgeInsets padding2() => const EdgeInsets.all(10);

EdgeInsets padding3() => const EdgeInsets.all(15);

EdgeInsets symmetricVerticalPadding1() =>
    const EdgeInsets.symmetric(vertical: 10);

EdgeInsets symmetricVerticalPadding2() =>
    const EdgeInsets.symmetric(vertical: 15);

EdgeInsets symmetricHorizontalPadding1() =>
    const EdgeInsets.symmetric(horizontal: 10);

EdgeInsets symmetricHorizontalPadding2() =>
    const EdgeInsets.symmetric(horizontal: 15);

EdgeInsets symmetricHorizontalPadding3() =>
    const EdgeInsets.symmetric(horizontal: 20);

AppBar buildDefaultAppBar({required String title}) => AppBar(
      automaticallyImplyLeading: true,
      title: Text(
        title,
        style: const TextStyle(color: whiteColor),
      ),
    );

class BuildDefaultGradientButton extends StatelessWidget {
  final double height, width;
  final Widget child;
  final VoidCallback? onClick;
  final Function(TapUpDetails?)? onTapUp;

  const BuildDefaultGradientButton(
      {Key? key,
      required this.child,
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
          boxShadow: const [
            BoxShadow(
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
  final VoidCallback onClick;
  final Color color;

  const BuildDefaultIconButton(
      {Key? key,
      required this.icon,
      required this.onClick,
      this.color = whiteColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        size: 26.sp,
        color: color,
      ),
      onPressed: onClick,
    );
  }
}

class BuildDefaultTextButton extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final double fontSize;
  final Color buttonColor;

  const BuildDefaultTextButton({
    Key? key,
    required this.text,
    required this.onClick,
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

class GradientText extends StatelessWidget {
  const GradientText(this.text, {Key? key, this.style, this.textAlign})
      : super(key: key);

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

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
    Key? key,
    required this.icon,
    required this.size,
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
  const BuildLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (Platform.isAndroid)
          ? CircularProgressIndicator(
              valueColor: context
                      .select<AppThemeProvider, bool>((value) => value.isDark)
                  ? const AlwaysStoppedAnimation<Color>(Colors.white)
                  : const AlwaysStoppedAnimation<Color>(mainColor),
            )
          : const CupertinoActivityIndicator(),
    );
  }
}

class BuildErrorWidget extends StatelessWidget {
  final ErrorResult errorResult;

  const BuildErrorWidget({Key? key, required this.errorResult})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 220.h,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        color: transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              errorResult.errorImage,
              height: 150.w,
              width: 150.w,
              fit: BoxFit.fill,
            ),
            Container(
              width: double.infinity,
              padding: padding2(),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: defaultBorderRadius(),
              ),
              child: Center(
                child: Text(
                  errorResult.errorMessage,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
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

class BuildAlertDialogWidget extends StatelessWidget {
  final String description, title;

  const BuildAlertDialogWidget(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        SizeConfigurationHelper.screenOrientation == Orientation.portrait;
    return AlertDialog(
      contentPadding: padding2(),
      backgroundColor: transparent,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: padding1(),
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: defaultBorderRadius(),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BuildDialogGradientText(
                    text: title,
                    fontSize: isPortrait ? 22.sp : 20.sp,
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 2.0,
                    height: 2.h,
                    endIndent: 10.0,
                    indent: 10.0,
                  ),
                  BuildDialogGradientText(
                    text: description,
                    fontSize: isPortrait ? 18.sp : 16.sp,
                  ),
                ],
              ),
            ),
            verticalSpace1(),
            GestureDetector(
              onTap: () => popNavigate(context),
              child: Container(
                height: 50.sp,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: defaultBorderRadius(),
                  border: Border.all(
                      color: Theme.of(context).primaryColor, width: 2.0),
                ),
                child: Center(
                    child: BuildDialogGradientText(
                  text: 'cancel'.tr(),
                  fontSize: 20.sp,
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildDialogGradientText extends StatelessWidget {
  final String text;
  final double fontSize;

  const BuildDialogGradientText(
      {Key? key, required this.text, required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<AppThemeProvider, bool>(
      selector: (context, provider) => provider.isDark,
      builder: (context, value, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => value
              ? const LinearGradient(colors: [mainDarkColor, mainDarkColor])
                  .createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                )
              : lightGradient().createShader(
                  Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                ),
          child: Text(
            text,
            style: TextStyle(
                color: whiteColor,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                height: 2),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

BuildDefaultIconButton copyButton(BuildContext context,
        {required String textValue}) =>
    BuildDefaultIconButton(
      icon: Icons.copy,
      onClick: () => copyText(context, textValue: textValue),
    );

BuildDefaultIconButton shareButton({required String textValue}) =>
    BuildDefaultIconButton(
      icon: Icons.share,
      onClick: () => shareText(textValue: textValue),
    );

BorderRadius defaultBorderRadius() => const BorderRadius.all(
      Radius.circular(10.0),
    );

LinearGradient lightGradient() => const LinearGradient(
    colors: [Colors.purple, Colors.indigo],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft);

LinearGradient darkGradient() =>
    const LinearGradient(colors: [mainDarkColor, mainDarkColor]);

void showToast({required String toastValue}) {
  Fluttertoast.showToast(
      msg: toastValue,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      textColor: Colors.white,
      backgroundColor: Colors.black87.withOpacity(0.5),
      fontSize: 16.sp);
}

Future<void> copyText(BuildContext context, {required String textValue}) async {
  await Clipboard.setData(ClipboardData(text: textValue));
  showToast(toastValue: 'copy_text'.tr());
}

Future<void> shareText({required String textValue}) async {
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
