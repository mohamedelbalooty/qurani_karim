import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/hadith.dart';
import 'package:qurany_karim/services/local_services/hadith_service.dart';
import 'package:qurany_karim/view_model/ahadith/states.dart';

class AhadithViewModel extends ChangeNotifier {
  AhadithStates states;
  OnRefreshState refreshState;
  OnLoadState loadState;

  List<Hadith> _ahadith;

  List<Hadith> get ahadith => _ahadith;

  List<Hadith> _ahadithDisplayed;

  List<Hadith> get ahadithDisplayed => _ahadithDisplayed;

  ErrorResult _error;

  ErrorResult get error => _error;

  String _refreshError;

  String get refreshError => _refreshError;

  int page = 1;

  HadithService _service = HadithService();

  Future<void> getAhadith(BuildContext context) async {
    states = AhadithStates.Loading;
    notifyListeners();
    await _service.getAhadith(context).then((value) {
      value.fold((left) {
        _ahadith = left.take(10).toList();
        _ahadithDisplayed = _ahadith;
        states = AhadithStates.Loaded;
      }, (right) {
        _error = right;
        states = AhadithStates.Error;
      });
    });
    notifyListeners();
  }

  Future<void> onRefresh(BuildContext context,
      {@required RefreshController controller}) async {
    await Future.delayed(Duration(seconds: 2));
    try {
      await _service.getAhadith(context).then((value) {
        value.fold((left) {
          _ahadith.clear();
          page = 1;
          _ahadith = left.take(10).toList();
          _ahadithDisplayed = _ahadith;
          controller.refreshCompleted();
          refreshState = OnRefreshState.OnRefreshSuccessState;
        }, (right) {
          _error = right;
          controller.refreshFailed();
          refreshState = OnRefreshState.OnRefreshErrorState;
        });
      });
    } catch (exception) {
      _refreshError = 'error'.tr();
      controller.refreshFailed();
    }
    notifyListeners();
  }
  Future<void> onLoad(BuildContext context,
      {@required RefreshController controller}) async {
    if (page >= 1 && page < 5) {
      page += 1;
      try {
        await _service.getAhadith(context).then((value) {
          value.fold((left) async {
            _ahadith.clear();
            _ahadith = left
                .take(page == 2
                    ? 20
                    : page == 3
                        ? 30
                        : page == 4
                            ? 40
                            : 48)
                .toList();
            _ahadithDisplayed = _ahadith;
            await Future.delayed(Duration(seconds: 2));
            controller.loadComplete();
            loadState = OnLoadState.OnLoadSuccessState;
          }, (right) {
            controller.loadFailed();
            _refreshError = 'error'.tr();
            loadState = OnLoadState.OnLoadErrorState;
          });
        });
      } catch (onLoadException) {
        controller.loadFailed();
        _refreshError = 'error'.tr();
        loadState = OnLoadState.OnLoadErrorState;
      }
    } else {
      controller.loadFailed();
      _refreshError = 'load_error'.tr();
      loadState = OnLoadState.OnLoadErrorState;
    }
    notifyListeners();
  }

  void searchQuery(String searchKey){
    searchKey = searchKey.toLowerCase();
    _ahadithDisplayed = _ahadith.where((element) {
      var searchTerm = element.searchTerm.toLowerCase();
      return searchTerm.contains(searchKey);
    }).toList();
    notifyListeners();
  }

  void clearSearchTerms(){
    _ahadithDisplayed = _ahadith;
    notifyListeners();
  }

  void disposeData() {
    _ahadith.clear();
    _ahadithDisplayed.clear();
    page = 1;
  }
}
