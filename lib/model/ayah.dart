import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'ayah.g.dart';

@HiveType(typeId: 1)
class Ayah extends HiveObject {
  Ayah({
    @required this.text,
    @required this.numberInSurah,
  });

  @HiveField(0)
  final String text;
  @HiveField(1)
  final int numberInSurah;

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        text: json["text"],
        numberInSurah: json["numberInSurah"],
      );
}
