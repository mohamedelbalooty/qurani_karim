import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qurany_karim/model/assmaa_allah.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/repositories/assmaa_allah/local_service.dart';
import 'states.dart';

class AssmaaAllahViewModel extends ChangeNotifier {
  late AssmaaAllahStates states;
  late AssmaaAllahOnRefreshState refreshState;
  late AssmaaAllahOnLoadState loadState;

  AssmaaAllahViewModel() {
    states = AssmaaAllahStates.Initial;
    refreshState = AssmaaAllahOnRefreshState.OnRefreshInitialState;
    loadState = AssmaaAllahOnLoadState.OnLoadInitialState;
  }

  List<AssmaaAllah>? _assmaaAllah;

  List<AssmaaAllah> get assmaaAllah => _assmaaAllah!;

  ErrorResult? _error;

  ErrorResult get error => _error!;

  String? _refreshError;

  String get refreshError => _refreshError!;

  int page = 1;

  final AssmaaAllahLocalService _service = AssmaaAllahLocalService();

  Future<void> getAssmaaAllahAlhosna(BuildContext context) async {
    states = AssmaaAllahStates.Loading;
    notifyListeners();
    await _service.getAssmaaAllahAlhosna(context: context).then((value) {
      value.fold((left) {
        _assmaaAllah = left.getRange(0, 21).toList();
        states = AssmaaAllahStates.Loaded;
      }, (right) {
        _error = right;
        states = AssmaaAllahStates.Error;
      });
    });
    notifyListeners();
  }

  Future<void> onRefresh(BuildContext context,
      {required RefreshController controller}) async {
    await Future.delayed(const Duration(seconds: 2));
    try {
      await _service.getAssmaaAllahAlhosna(context: context).then((value) {
        value.fold((left) {
          _assmaaAllah!.clear();
          page = 1;
          _assmaaAllah = left.getRange(0, 21).toList();
          controller.refreshCompleted();
          refreshState = AssmaaAllahOnRefreshState.OnRefreshSuccessState;
        }, (right) {
          _error = right;
          controller.refreshFailed();
          refreshState = AssmaaAllahOnRefreshState.OnRefreshErrorState;
        });
      });
    } catch (exception) {
      _refreshError = 'error'.tr();
      controller.refreshFailed();
      refreshState = AssmaaAllahOnRefreshState.OnRefreshErrorState;
    }
    notifyListeners();
  }

  Future<void> onLoad(BuildContext context,
      {required RefreshController controller}) async {
    if (page >= 1 && page < 5) {
      page += 1;
      try {
        await _service.getAssmaaAllahAlhosna(context: context).then((value) {
          value.fold((left) async {
            _assmaaAllah!.addAll(page == 2
                ? left.getRange(21, 41).toList()
                : page == 3
                    ? left.getRange(41, 61).toList()
                    : page == 4
                        ? left.getRange(61, 81).toList()
                        : left.getRange(81, 99).toList());
            await Future.delayed(const Duration(seconds: 2));
            controller.loadComplete();
            loadState = AssmaaAllahOnLoadState.OnLoadSuccessState;
          }, (right) {
            controller.loadFailed();
            _refreshError = 'error'.tr();
            loadState = AssmaaAllahOnLoadState.OnLoadErrorState;
          });
        });
      } catch (onLoadException) {
        controller.loadFailed();
        _refreshError = 'error'.tr();
        loadState = AssmaaAllahOnLoadState.OnLoadErrorState;
      }
    } else {
      controller.loadFailed();
      _refreshError = 'load_error'.tr();
      loadState = AssmaaAllahOnLoadState.OnLoadErrorState;
    }
    notifyListeners();
  }

  void disposeData() {
    _assmaaAllah!.clear();
    page = 1;
  }
}
