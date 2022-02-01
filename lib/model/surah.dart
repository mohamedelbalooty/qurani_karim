import 'package:flutter/material.dart';
import 'ayah.dart';

class Surah {
  Surah({
    @required this.number,
    @required this.name,
    @required this.revelationType,
    @required this.ayahs,
  });

  final int number;
  final String name;
  final RevelationType revelationType;
  final List<Ayah> ayahs;

  factory Surah.fromJson(Map<String, dynamic> json) => Surah(
        number: json["number"],
        name: json["name"],
        revelationType: revelationTypeValues.map[json["revelationType"]],
        ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromJson(x))),
      );
}

enum RevelationType { MECCAN, MEDINAN }

final revelationTypeValues = EnumValues(
    {"Meccan": RevelationType.MECCAN, "Medinan": RevelationType.MEDINAN});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
