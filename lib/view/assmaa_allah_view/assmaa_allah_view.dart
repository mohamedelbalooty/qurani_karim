import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qurany_karim/ui_provider/app_theme_povider.dart';
import 'package:qurany_karim/ui_provider/toggle_provider.dart';
import 'package:qurany_karim/utils/helper/size_configuration_helper.dart';
import 'package:qurany_karim/utils/theme/colors.dart';
import 'package:qurany_karim/view/app_components.dart';
import 'package:qurany_karim/view_model/assmaa_allah/assmaa_allah_view_model.dart';
import 'package:qurany_karim/view_model/assmaa_allah/states.dart';

class AssmaaAllahView extends StatefulWidget {
  const AssmaaAllahView({super.key});
  static const String id = 'AssmaaAllahView';

  @override
  _AssmaaAllahViewState createState() => _AssmaaAllahViewState();
}

class _AssmaaAllahViewState extends State<AssmaaAllahView>
    with AfterLayoutMixin {
  late AssmaaAllahViewModel _assmaaAllahViewModel;
  final GlobalKey _refreshKey = GlobalKey();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void afterFirstLayout(BuildContext context) {
    _assmaaAllahViewModel =
        Provider.of<AssmaaAllahViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        SizeConfigurationHelper.screenOrientation == Orientation.portrait;
    return Scaffold(
      appBar: buildDefaultAppBar(title: 'asmaa_allah'.tr()),
      body: Consumer<AssmaaAllahViewModel>(
        builder: (context, provider, child) {
          if (provider.states == AssmaaAllahStates.Loading) {
            return const BuildLoadingWidget();
          } else if (provider.states == AssmaaAllahStates.Loaded) {
            return FadeInRight(
              child: SmartRefresher(
                key: _refreshKey,
                controller: _refreshController,
                enablePullUp: true,
                physics: const BouncingScrollPhysics(),
                footer: const ClassicFooter(
                  loadStyle: LoadStyle.ShowWhenLoading,
                ),
                onRefresh: () {
                  provider.onRefresh(context, controller: _refreshController);
                  if (provider.refreshState ==
                      AssmaaAllahOnRefreshState.OnRefreshErrorState) {
                    showToast(toastValue: provider.refreshError);
                  }
                },
                onLoading: () {
                  provider.onLoad(context, controller: _refreshController);
                  if (provider.loadState ==
                      AssmaaAllahOnLoadState.OnLoadErrorState) {
                    showToast(toastValue: provider.refreshError);
                  }
                },
                child: GridView.builder(
                    padding: symmetricVerticalPadding1(),
                    itemCount: provider.assmaaAllah.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isPortrait ? 3 : 5,
                      mainAxisSpacing: 5.0,
                      crossAxisSpacing: 5.0,
                    ),
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          context
                              .read<ToggleProvider>()
                              .toggle(index)
                              .then((value) => showDialog(
                                    context: context,
                                    builder: (_) {
                                      return BuildAlertDialogWidget(
                                        title: 'description'.tr(),
                                          description: provider
                                              .assmaaAllah[index].description);
                                    },
                                  ));
                        },
                        child: context.watch<ToggleProvider>().selectedIndex ==
                                index
                            ? Container(
                                color: whiteColor,
                                child: Center(
                                  child: Selector<AppThemeProvider, bool>(
                                    selector: (context, provider) =>
                                        provider.isDark,
                                    builder: (context, value, child) {
                                      return ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (bounds) => value
                                            ? const LinearGradient(colors: [
                                                mainDarkColor,
                                                mainDarkColor
                                              ]).createShader(
                                                Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    bounds.width,
                                                    bounds.height),
                                              )
                                            : lightGradient().createShader(
                                                Rect.fromLTWH(
                                                    0,
                                                    0,
                                                    bounds.width,
                                                    bounds.height),
                                              ),
                                        child: Text(
                                          provider.assmaaAllah[index].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                          textAlign: TextAlign.center,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Selector<AppThemeProvider, bool>(
                                selector: (context, provider) =>
                                    provider.isDark,
                                builder: (context, value, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      gradient: value
                                          ? darkGradient()
                                          : lightGradient(),
                                    ),
                                    child: Center(
                                      child: Text(
                                        provider.assmaaAllah[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline2!
                                            .copyWith(color: whiteColor),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    }),
              ),
            );
          } else {
            return BuildErrorWidget(
              errorResult: provider.error,
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _assmaaAllahViewModel.disposeData();
    super.dispose();
  }
}
