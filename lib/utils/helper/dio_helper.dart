import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioHelper{
  static Dio dio;
  static init(){
    dio = Dio();
  }

  static Future<Response> getData({@required String url}) async{
    return await dio.get(url);
  }
}