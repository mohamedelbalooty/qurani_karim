import 'package:flutter/material.dart';

class ChangeFontSizeProvider extends ChangeNotifier {
  int fontSize = 18;

  void increaseFontSize() {
    if(fontSize < 30){
      fontSize++;
    }
    notifyListeners();
  }

  void decreaseFontSize() {
    if(fontSize > 14){
      fontSize--;
    }
    notifyListeners();
  }
}
