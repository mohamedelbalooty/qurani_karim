import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  ///INSTANCE OF SHARED PREFERENCES
  static SharedPreferences sharedPreferences;

  ///INITIALIZATION OF SHARED PREFERENCES OBJECT
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  ///SET BOOLEAN DATA
  static Future<bool> setBooleanData(
      {@required String key, @required bool value}) async {
    return await sharedPreferences.setBool(key, value);
  }

  ///GET BOOLEAN DATA
  static bool getBooleanData({@required String key}) {
    return sharedPreferences.getBool(key);
  }

  ///SET STRING DATA
  static Future<bool> setStringData(
      {@required String key, @required String value}) async {
    return await sharedPreferences.setString(key, value);
  }

  ///GET STRING DATA
  static String getStringData({@required String key}) {
    return sharedPreferences.getString(key);
  }

  static Future<bool> setIntData(
      {@required String key, @required int value}) async {
    return await sharedPreferences.setInt(key, value);
  }

  ///GET STRING DATA
  static int getIntData({@required String key}) {
    return sharedPreferences.getInt(key);
  }


  static Future<bool> setListData({@required String key, @required List<String> value}){
    return sharedPreferences.setStringList(key, value);
  }

  static List<String> getListData({@required String key}) {
    return sharedPreferences.getStringList(key);
  }

  ///REMOVE FROM SHARED PREFERENCES
  static Future<bool> removeData({@required String key}) async {
    return await sharedPreferences.remove(key);
  }
}