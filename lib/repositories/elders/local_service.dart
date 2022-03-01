import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:qurany_karim/model/elder.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/repositories/elders/repository.dart';

class EldersLocalService extends EldersRepository {
  @required
  Future<Either<List<Elder>, ErrorResult>> getElders(
      {@required BuildContext context}) async {
    try {
      var response = await DefaultAssetBundle.of(context)
          .loadString('assets/json_db/elders.json');
      List<dynamic> jsonData = jsonDecode(response);
      List<Elder> elders = jsonData.map((e) => Elder.fromJson(e)).toList();
      return Left(elders);
    } catch (exception) {
      ErrorResult error = ErrorResult(
          errorMessage: 'local_exception'.tr(),
          errorImage: 'assets/icons/storage_error.png');
      return Right(error);
    }
  }
}
