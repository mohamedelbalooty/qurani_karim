import 'package:flutter/material.dart';
import 'package:qurany_karim/utils/constants/cache_keys.dart';
import 'package:qurany_karim/utils/helper/cache_helper.dart';

class TasbihProvider extends ChangeNotifier {
  int tasbihNumber = 0;

  void tasbih() {
    tasbihNumber++;
    notifyListeners();
  }

  void reset() {
    tasbihNumber = 0;
    notifyListeners();
  }

  String selectedValue = 'سبحان الله';
  List<String> tasbihData = ['سبحان الله', 'الحمد لله', 'لا اله الا الله', 'الله اكبر'];

  bool collaps = false;
  selectCurrentValue({@required String value}){
    collaps = false;
    selectedValue = value;
    notifyListeners();
  }
}
