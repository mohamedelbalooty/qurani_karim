import 'package:flutter/material.dart';
import 'package:qurany_karim/utils/constants/cache_keys.dart';
import 'package:qurany_karim/utils/helper/cache_helper.dart';

class AppThemeProvider extends ChangeNotifier {
  bool cacheTheme = CacheHelper.getBooleanData(key: themeKey);

  AppThemeProvider() {
    changeAppTheme(currentTheme: cacheTheme);
  }

  bool isDark = true;

  void changeAppTheme({bool? currentTheme}) {
    if (currentTheme != null) {
      isDark = currentTheme;
      notifyListeners();
    } else {
      isDark = !isDark;
      CacheHelper.setBooleanData(key: themeKey, value: isDark);
      notifyListeners();
    }
  }
}
