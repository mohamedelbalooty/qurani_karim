import 'package:flutter/material.dart';

class ToggleProvider extends ChangeNotifier {
  int selectedIndex = 0;

  Future<void> toggle(int index) async{
    selectedIndex = index;
    notifyListeners();
  }
}
