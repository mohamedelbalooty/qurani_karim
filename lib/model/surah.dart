import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'ayah.dart';
part 'surah.g.dart';

@HiveType(typeId: 0)
class Surah extends HiveObject {
  Surah({
    @required this.number,
    @required this.name,
    @required this.revelationType,
    @required this.ayahs,
  });

  @HiveField(0)
  int number;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String revelationType;
  @HiveField(3)
  final List<Ayah> ayahs;

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json["number"],
        name: json["name"],
        revelationType: json["revelationType"],
        ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
      );
}

