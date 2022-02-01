import 'package:flutter/material.dart';

class Ayah {
  Ayah({
    @required this.text,
    @required this.numberInSurah,
  });

  final String text;
  final int numberInSurah;

  factory Ayah.fromJson(Map<String, dynamic> json) => Ayah(
        text: json["text"],
        numberInSurah: json["numberInSurah"],
      );
}
