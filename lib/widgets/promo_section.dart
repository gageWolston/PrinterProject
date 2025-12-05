import 'package:flutter/material.dart';

class PromoSection extends StatelessWidget {
  final List<PromoItem> promos = [
    PromoItem(
      title: 'Top Seller',
      description: 'The best-selling printer this month!',
      color: Colors.blue,
      clickable: true,
    ),
    PromoItem(
      title: '10% OFF Coupon',
      description: 'Save on your next purchase!',
      color: Colors.green,
      clickable: true,
    ),
    PromoItem(
      title: 'New Arrival',
      description: 'Check out our latest model!',
      color: Colors.orange,
      clickable: false, // 👈 not clickable
    ),
    PromoItem(
      title: 'Holiday Sale',
      description: 'Huge discounts on all models!',
      color: Colors.red,
      clickable: true,
    ),
  ];

  PromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      margin: EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 10),
        itemCount: promos.length,
        itemBuilder: (context, index) {
          final promo = promos[index];
          final card = Container(
            width: 250,
            margin: EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: promo.color,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  promo.description,
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );

          // Wrap clickable promos in GestureDetector
          return promo.clickable
              ? GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${promo.title} clicked')),
                    );
                  },
                  child: card,
                )
              : card;
        },
      ),
    );
  }
}

class PromoItem {
  final String title;
  final String description;
  final Color color;
  final bool clickable;

  PromoItem({
    required this.title,
    required this.description,
    required this.color,
    required this.clickable,
  });
}
