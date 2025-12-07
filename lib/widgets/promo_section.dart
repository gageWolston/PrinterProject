import 'package:flutter/material.dart';

import '../models/promo.dart';
import '../promo_detail_page.dart';
import '../theme.dart';

class PromoSection extends StatelessWidget {
  final List<PromoItem> promos = const [
    PromoItem(
      title: 'Top Seller',
      description: 'The best-selling printer this month!',
      color: AppPalette.primary,
      highlights: [
        'Curated recommendations based on real orders',
        'Fast delivery included with purchase',
        'Extended warranty pricing unlocked',
      ],
    ),
    PromoItem(
      title: '10% OFF Coupon',
      description: 'Save on your next purchase!',
      color: AppPalette.accent,
      highlights: [
        'Automatic checkout application',
        'Works with bundles and supplies',
        'Limited time seasonal savings',
      ],
    ),
    PromoItem(
      title: 'New Arrival',
      description: 'Check out our latest model!',
      color: AppPalette.secondary,
      highlights: [
        'Performance tuned for photo printing',
        'Energy efficient, low-noise hardware',
        'Trade-in credits available',
      ],
    ),
    PromoItem(
      title: 'Holiday Sale',
      description: 'Huge discounts on all models!',
      color: Colors.teal,
      highlights: [
        'Doorbuster pricing on top printers',
        'Bonus ink bundle while supplies last',
        'Extended return window for gifts',
      ],
    ),
  ];

  const PromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: promos.length,
        itemBuilder: (context, index) {
          final promo = promos[index];
          final card = Container(
            width: 250,
            margin: const EdgeInsets.only(right: 12, top: 10, bottom: 6),
            decoration: BoxDecoration(
              color: promo.color,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo.title,
                  style: textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  promo.description,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
              ],
            ),
          );

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PromoDetailPage(promo: promo),
                ),
              );
            },
            child: card,
          );
        },
      ),
    );
  }
}
