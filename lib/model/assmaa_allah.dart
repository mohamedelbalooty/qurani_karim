import 'package:flutter/material.dart';

class AssmaaAllah {
  const AssmaaAllah({
    @required this.id,
    @required this.name,
    @required this.description,
  });

  final int id;
  final String name;
  final String description;

  factory AssmaaAllah.fromJson(Map<String, dynamic> json) => AssmaaAllah(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );
}
