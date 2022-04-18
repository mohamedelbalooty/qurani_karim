import 'package:dio/dio.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(baseUrl: 'https://api.alquran.cloud/v1/'),
    );
  }

  static Future<Response> getData(
      {required String url, Options? options}) async {
    return await dio.get(url, options: options);
  }

  static Future<Response> postData(
      {required String url, required Options options, required data}) async {
    return await dio.post(url, options: options, data: data);
  }
}
