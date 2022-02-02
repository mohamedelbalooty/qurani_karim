import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qurany_karim/core/status_code_errors.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/repositories/quran/repository.dart';
import 'package:qurany_karim/utils/helper/dio_helper.dart';

class QuranRemoteService extends QuranRepository {
  @override
  Future<Either<List<Surah>, ErrorResult>> getQuranData() async {
    try {
      var response = await DioHelper.getData(url: 'quran/quran-uthmani');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        List<dynamic> data = jsonData['data']['surahs'];
        print(data.first);
        print(data.length);
        List<Surah> quranData = data.map((e) => Surah.fromJson(e)).toList();
        return Left(quranData);
      } else {
        return Right(returnResponse(response));
      }
    } on DioError catch (exception) {
      return Right(returnResponse(exception.response));
    }
  }
}
