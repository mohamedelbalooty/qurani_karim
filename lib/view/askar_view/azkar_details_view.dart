import 'package:after_layout/after_layout.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/view_model/azkar/azkar_view_model.dart';
import 'package:qurany_karim/view_model/azkar/states.dart';
import '../app_components.dart';
import 'components.dart';

class AzkarDetailsView extends StatefulWidget {
  final String title;

  const AzkarDetailsView({Key? key, required this.title}) : super(key: key);

  @override
  _AzkarDetailsViewState createState() => _AzkarDetailsViewState();
}

class _AzkarDetailsViewState extends State<AzkarDetailsView>
    with AfterLayoutMixin {
  late AzkarViewModel _azkarViewModel;

  @override
  void afterFirstLayout(BuildContext context) {
    _azkarViewModel = Provider.of<AzkarViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(title: widget.title),
      body: Consumer<AzkarViewModel>(
        builder: (context, provider, child) {
          if (provider.detailsStates == AzkarDetailsStates.Loading) {
            return const BuildLoadingWidget();
          } else if (provider.detailsStates == AzkarDetailsStates.Loaded) {
            return ElasticInUp(
              child: ListView.separated(
                padding: padding2(),
                physics: const BouncingScrollPhysics(),
                itemCount: provider.azkarDetails.length,
                itemBuilder: (_, index) {
                  return BuildAzkarDetailsItemWidget(
                    details: provider.azkarDetails[index],
                  );
                },
                separatorBuilder: (_, index) => verticalSpace2(),
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
    _azkarViewModel.disposeData();
    super.dispose();
  }
}
