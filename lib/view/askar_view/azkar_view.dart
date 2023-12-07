import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:qurany_karim/view_model/azkar/azkar_view_model.dart';
import 'package:qurany_karim/view_model/azkar/states.dart';
import '../app_components.dart';
import 'azkar_details_view.dart';
import 'components.dart';

class AzkarView extends StatelessWidget {
  const AzkarView({super.key});
  static const String id = 'AzkarView';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildDefaultAppBar(title: 'azkar'.tr()),
      body: Consumer<AzkarViewModel>(
        builder: (context, provider, child) {
          if (provider.categoriesStates == AzkarCategoriesStates.Initial) {
            provider.getCategories(context);
            return const BuildLoadingWidget();
          } else if (provider.categoriesStates ==
              AzkarCategoriesStates.Loading) {
            return const BuildLoadingWidget();
          } else if (provider.categoriesStates ==
              AzkarCategoriesStates.Loaded) {
            return FadeInRight(
              child: ListView.separated(
                padding: symmetricVerticalPadding1(),
                physics: const BouncingScrollPhysics(),
                itemCount: provider.categories.length,
                itemBuilder: (_, index) {
                  return BuildAzkarCategoryWidgetItem(
                    name: provider.categories[index].name,
                    onClick: () async {
                      await provider.getAzkarDetails(context,
                          categoryId: provider.categories[index].id);
                      materialNavigator(
                        context,
                        AzkarDetailsView(
                            title: provider.categories[index].name),
                      );
                    },
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
}