import 'package:flutter/material.dart';

class ChangeFontSizeProvider extends ChangeNotifier {
  int fontSize = 18;

  void increaseFontSize() {
    fontSize++;
    notifyListeners();
  }

  void decreaseFontSize() {
    fontSize--;
    notifyListeners();
  }
}
