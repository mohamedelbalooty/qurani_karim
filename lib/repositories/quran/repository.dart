import 'package:dartz/dartz.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/surah.dart';

abstract class QuranRepository{
  Future<Either<List<Surah>, ErrorResult>> getQuranData();
}