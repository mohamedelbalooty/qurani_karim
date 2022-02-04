import 'package:flutter/material.dart';

// class SurahAudio {
//   SurahAudio({
//     @required this.ayah,
//   });
//
//   final List<AyahAudio> ayah;
//
//   factory SurahAudio.fromJson(Map<String, dynamic> json) => SurahAudio(
//         ayah:
//             List<AyahAudio>.from(json["ayah"].map((x) => AyahAudio.fromJson(x))),
//       );
// }

class AyahAudio {
  AyahAudio({
    @required this.audio,
  });

  final String audio;

  factory AyahAudio.fromJson(Map<String, dynamic> json) => AyahAudio(
        audio: json["audio"],
      );
}
