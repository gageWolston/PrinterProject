import 'package:flutter/material.dart';

class PromoItem {
  final String title;
  final String description;
  final Color startColor;
  final Color endColor;
  final String printerId;

  const PromoItem({
    required this.title,
    required this.description,
    required this.startColor,
    required this.endColor,
    required this.printerId,
  });
}
