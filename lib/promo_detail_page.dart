import 'package:flutter/material.dart';

import 'models/promo.dart';
import 'theme.dart';

class PromoDetailPage extends StatelessWidget {
  final PromoItem promo;

  const PromoDetailPage({required this.promo, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(promo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: promo.color.withAlpha((0.1 * 255).round()),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: promo.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    promo.description,
                    style: TextStyle(
                      color: colorScheme.onSurface.withAlpha((0.8 * 255).round()),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (promo.highlights.isNotEmpty)
              ...[
                const Text(
                  'Why you\'ll love this',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                ...promo.highlights.map(
                  (h) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.check_circle, color: AppPalette.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            h,
                            style: TextStyle(
                                  color: colorScheme.onSurface.withAlpha((0.85 * 255).round()),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
          ],
        ),
      ),
    );
  }
}
