import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:qurany_karim/model/error_result.dart';
import 'package:qurany_karim/model/hadith.dart';

abstract class AhadithRepository{
  Future<Either<List<Hadith>, ErrorResult>> getAhadith({required BuildContext context});
}