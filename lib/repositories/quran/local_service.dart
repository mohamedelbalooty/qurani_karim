import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah.dart';
import 'package:qurany_karim/repositories/quran/repository.dart';

class QuranLocalService extends QuranRepository{
  @override
  Future<Either<List<Surah>, ErrorResult>> getQuranData() {
    // TODO: implement getQuranData
    throw UnimplementedError();
  }

}