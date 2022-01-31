import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qurany_karim/ui_provider/toggle_provider.dart';
import 'package:qurany_karim/utils/constants/colors.dart';
import 'package:qurany_karim/view/app_components.dart';
import 'package:qurany_karim/view_model/assmaa_allah/assmaa_allah_view_model.dart';
import 'package:qurany_karim/view_model/assmaa_allah/states.dart';
import 'components.dart';

class AssmaaAllahView extends StatefulWidget {
  const AssmaaAllahView({Key key}) : super(key: key);
  static const String id = 'AssmaaAllahView';

  @override
  _AssmaaAllahViewState createState() => _AssmaaAllahViewState();
}

class _AssmaaAllahViewState extends State<AssmaaAllahView>
    with AfterLayoutMixin {
  AssmaaAllahViewModel _assmaaAllahViewModel;
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
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Hero(
          tag: 'asmaa_allah'.tr(),
          child: Text('asmaa_allah'.tr()),
        ),
      ),
      body: Consumer<AssmaaAllahViewModel>(
        builder: (context, provider, child) {
          if (provider.states == AssmaaAllahStates.Loading) {
            return BuildLoadingWidget();
          } else if (provider.states == AssmaaAllahStates.Loaded) {
            return SmartRefresher(
              key: _refreshKey,
              controller: this._refreshController,
              enablePullUp: true,
              physics: BouncingScrollPhysics(),
              footer: ClassicFooter(
                loadStyle: LoadStyle.ShowWhenLoading,
              ),
              onRefresh: () {
                provider.onRefresh(context, controller: _refreshController);
                if (provider.refreshState ==
                    AssmaaAllahOnRefreshState.OnRefreshErrorState) {
                  showToast(context, toastValue: provider.refreshError);
                }
              },
              onLoading: () {
                provider.onLoad(context, controller: _refreshController);
                if (provider.loadState ==
                    AssmaaAllahOnLoadState.OnLoadErrorState) {
                  showToast(context, toastValue: provider.refreshError);
                }
              },
              child: GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
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
                                        text: provider
                                            .assmaaAllah[index].description);
                                  },
                                ));
                      },
                      child: context.watch<ToggleProvider>().selectedIndex ==
                              index
                          ? Container(
                              color: whiteColor,
                              child: Center(
                                child: GradientText(
                                  provider.assmaaAllah[index].name,
                                  style: Theme.of(context).textTheme.headline2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: defaultGradient(),
                              ),
                              child: Center(
                                child: Text(
                                  provider.assmaaAllah[index].name,
                                  style: Theme.of(context).textTheme.headline2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    );
                  }),
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
