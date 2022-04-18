import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:qurany_karim/model/assmaa_allah.dart';
import 'package:qurany_karim/model/error_result.dart';

abstract class AssmaaAllahRepository{
  Future<Either<List<AssmaaAllah>, ErrorResult>> getAssmaaAllahAlhosna({required BuildContext context});
}