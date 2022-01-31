import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/hadith.dart';
import 'package:qurany_karim/services/local_services/hadith_service.dart';
import 'package:qurany_karim/view_model/ahadith/states.dart';

class AhadithViewModel extends ChangeNotifier {
  AhadithStates states;
  AhadithOnRefreshState refreshState;
  AhadithOnLoadState loadState;

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
        _ahadith = left.getRange(0, 11).toList();
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
          _ahadith = left.getRange(0, 11).toList();
          _ahadithDisplayed = _ahadith;
          controller.refreshCompleted();
          refreshState = AhadithOnRefreshState.OnRefreshSuccessState;
        }, (right) {
          _error = right;
          controller.refreshFailed();
          refreshState = AhadithOnRefreshState.OnRefreshErrorState;
        });
      });
    } catch (exception) {
      _refreshError = 'error'.tr();
      controller.refreshFailed();
      refreshState = AhadithOnRefreshState.OnRefreshErrorState;
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
            _ahadith.addAll(page == 2 ? left.getRange(11, 21).toList() : page == 3 ? left.getRange(21, 31).toList() : page == 4 ? left.getRange(31, 41).toList() : left.getRange(41, 48).toList());
            // _ahadith = left
            //     .take(page == 2
            //         ? 20
            //         : page == 3
            //             ? 30
            //             : page == 4
            //                 ? 40
            //                 : 48)
            //     .toList();
            _ahadithDisplayed = _ahadith;
            await Future.delayed(Duration(seconds: 2));
            controller.loadComplete();
            loadState = AhadithOnLoadState.OnLoadSuccessState;
          }, (right) {
            controller.loadFailed();
            _refreshError = 'error'.tr();
            loadState = AhadithOnLoadState.OnLoadErrorState;
          });
        });
      } catch (onLoadException) {
        _refreshError = 'error'.tr();
        controller.loadFailed();
        loadState = AhadithOnLoadState.OnLoadErrorState;
      }
    } else {
      _refreshError = 'load_error'.tr();
      controller.loadFailed();
      loadState = AhadithOnLoadState.OnLoadErrorState;
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
