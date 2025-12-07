import 'package:flutter/material.dart';

class PromoItem {
  final String title;
  final String description;
  final Color color;
  final List<String> highlights;

  const PromoItem({
    required this.title,
    required this.description,
    required this.color,
    this.highlights = const [],
  });
}
