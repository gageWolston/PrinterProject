import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/printer.dart';
import 'services/cart_service.dart';
import 'widgets/animated_button.dart';

class PrinterDetailPage extends StatelessWidget {
  final Printer printer;

  const PrinterDetailPage({required this.printer, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(printer.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  printer.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(printer.type),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      printer.brand,
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 6),
                Text('${printer.rating} rating'),
                const SizedBox(width: 16),
                Text(
                  '\$${printer.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(printer.connectivity),
                  backgroundColor:
                      Theme.of(context).colorScheme.secondaryContainer,
                ),
                ...printer.features
                    .map(
                      (feature) => Chip(
                        label: Text(feature),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      ),
                    )
                    .toList(),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              printer.description,
              style: TextStyle(color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: printer.highlights
                  .map(
                    (h) => Chip(
                      label: Text(h),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Consumer<CartService>(
              builder: (context, cart, _) {
                return AnimatedActionButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    cart.addItem(printer);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${printer.name} added to cart')),
                    );
                  },
                  child: const Text('Add to Cart'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
