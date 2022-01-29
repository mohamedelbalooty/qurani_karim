import 'package:flutter/material.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/hadith.dart';
import 'package:qurany_karim/services/local_services/hadith_service.dart';
import 'package:qurany_karim/view_model/ahadith/states.dart';

class AhadithViewModel extends ChangeNotifier {
  AhadithStates states;

  List<Hadith> _ahadith;

  List<Hadith> get ahadith => _ahadith;

  ErrorResult _error;

  ErrorResult get error => _error;
  HadithService _service = HadithService();

  Future<void> getAhadith(BuildContext context,
      {@required int categoryId}) async {
    states = AhadithStates.Loading;
    notifyListeners();
    await _service.getAhadith(context).then((value) {
      value.fold((left) {
        _ahadith = left.take(10);
        states = AhadithStates.Loaded;
      }, (right) {
        _error = right;
        states = AhadithStates.Error;
      });
    });
    notifyListeners();
  }

  

  void disposeData() {
    _ahadith.clear();
  }
}
