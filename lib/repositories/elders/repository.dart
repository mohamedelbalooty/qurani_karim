import 'package:dartz/dartz.dart';
import 'package:qurany_karim/model/elder.dart';
import 'package:qurany_karim/model/error_result.dart';

abstract class EldersRepository{
  Future<Either<List<Elder>, ErrorResult>> getElders();
}