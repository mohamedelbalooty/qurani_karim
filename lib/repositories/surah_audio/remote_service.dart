import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/core/status_code_errors.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah_audio.dart';
import 'package:qurany_karim/utils/helper/dio_helper.dart';
import 'repository.dart';

class SurahAudioRemoteService extends SurahAudioRepository {
  @override
  Future<Either<List<AyahAudio>, ErrorResult>> getSurahAudio(
      {@required int surahId, @required String elderFormat}) async {
    try {
      var response =
          await DioHelper.getData(url: 'surah/$surahId/$elderFormat');
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = response.data;
        // print(jsonData);
        List<dynamic> data = jsonData['data']['ayahs'];
        // print(data);
        List<AyahAudio> surahAudio =
            data.map((e) => AyahAudio.fromJson(e)).toList();
        print(surahAudio.first.audio);
        return Left(surahAudio);
      } else {
        return Right(returnResponse(response));
      }
    } on DioError catch (dioException) {
      if (dioException.type == DioErrorType.response) {
        return Right(returnResponse(dioException.response));
      } else {
        return Right(
          ErrorResult(
              errorMessage: 'error'.tr(),
              errorImage: 'assets/icons/no-internet.png'),
        );
      }
    }
  }
}
