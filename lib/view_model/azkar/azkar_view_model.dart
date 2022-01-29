import 'package:flutter/material.dart';
import 'package:qurany_karim/model/azkar_category.dart';
import 'package:qurany_karim/model/azkar_details.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/services/local_services/azkar_service.dart';
import 'states.dart';

class AzkarViewModel extends ChangeNotifier {
  AzkarViewModel() {
    categoriesStates = AzkarCategoriesStates.Initial;
  }

  AzkarCategoriesStates categoriesStates;
  AzkarDetailsStates detailsStates;

  List<AzkarCategory> _categories;

  List<AzkarCategory> get categories => _categories;

  List<AzkarDetails> _azkarDetails;

  List<AzkarDetails> get azkarDetails => _azkarDetails;

  ErrorResult _error;

  ErrorResult get error => _error;

  AzkarService _service = AzkarService();

  Future<void> getCategories(BuildContext context) async {
    categoriesStates = AzkarCategoriesStates.Loading;
    await _service.getCategories(context).then((value) {
      value.fold((left) {
        _categories = left;
        categoriesStates = AzkarCategoriesStates.Loaded;
      }, (right) {
        _error = right;
        categoriesStates = AzkarCategoriesStates.Error;
      });
    });
    notifyListeners();
  }

  Future<void> getAzkarDetails(BuildContext context,
      {@required int categoryId}) async {
    _azkarDetails = [];
    detailsStates = AzkarDetailsStates.Loading;
    notifyListeners();
    await _service
        .getAzkarDetails(context, categoryId: categoryId)
        .then((value) {
      value.fold((left) {
        for (var item in left) {
          if (item.id == categoryId) {
            _azkarDetails.add(item);
          }
        }
        detailsStates = AzkarDetailsStates.Loaded;
        notifyListeners();
      }, (right) {
        _error = right;
        detailsStates = AzkarDetailsStates.Error;
      });
    });
    notifyListeners();
  }

  void disposeData() {
    _azkarDetails.clear();
  }
}
