import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:dartz/dartz.dart';
import 'dart:convert';
import 'package:qurany_karim/model/azkar_category.dart';
import 'package:qurany_karim/model/azkar_details.dart';
import 'package:qurany_karim/model/error_result.dart';

class AzkarService {
  Future<Either<List<AzkarCategory>, ErrorResult>> getCategories(
      BuildContext context) async {
    try {
      var response = await DefaultAssetBundle.of(context)
          .loadString('assets/json_db/azkar_category.json');
      List<dynamic> jsonData = jsonDecode(response);
      List<AzkarCategory> categories =
          jsonData.map((e) => AzkarCategory.fromJson(e)).toList();
      return Left(categories);
    } catch (exception) {
      ErrorResult error = ErrorResult(
          errorMessage: 'local_exception'.tr(),
          errorImage: 'assets/icons/storage_error.png');
      return Right(error);
    }
  }

  Future<Either<List<AzkarDetails>, ErrorResult>> getAzkarDetails(
      BuildContext context) async {
    try {
      var response = await DefaultAssetBundle.of(context)
          .loadString('assets/json_db/azkar_category_details.json');
      List<dynamic> jsonData = jsonDecode(response);
      List<AzkarDetails> details =
          jsonData.map((e) => AzkarDetails.fromJson(e)).toList();
      return Left(details);
    } catch (exception) {
      ErrorResult error = ErrorResult(
          errorMessage: 'local_exception'.tr(),
          errorImage: 'assets/icons/storage_error.png');
      return Right(error);
    }
  }
}
