import 'package:flutter/material.dart';

class AzkarDetails {
  final int id;
  final String count, description, reference, content;

  const AzkarDetails(
      {@required this.id,
      @required this.count,
      @required this.description,
      @required this.reference,
      @required this.content});

  factory AzkarDetails.fromJson(Map<String, dynamic> json) {
    return AzkarDetails(
        id: json['id'],
        count: json['count'],
        description: json['description'],
        reference: json['reference'],
        content: json['content']);
  }
}
