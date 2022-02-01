import 'package:dartz/dartz.dart';
import 'package:qurany_karim/model/azkar_category.dart';
import 'package:qurany_karim/model/azkar_details.dart';
import 'package:qurany_karim/model/error_result.dart';

abstract class AzkarRepository{
  Future<Either<List<AzkarCategory>, ErrorResult>> getCategories();
  Future<Either<List<AzkarDetails>, ErrorResult>> getAzkarDetails();
}