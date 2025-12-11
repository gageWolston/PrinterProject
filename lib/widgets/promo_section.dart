import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/promo.dart';
import '../models/printer.dart';
import '../services/cart_service.dart';
import '../services/printer_service.dart';

class PromoSection extends StatelessWidget {
  const PromoSection({super.key});

  List<(PromoItem, Printer)> _availablePromos(PrinterService service) {
    const promos = [
      PromoItem(
        title: 'TOP SELLER',
        startColor: Color.fromARGB(255, 50, 131, 224),
        endColor: Color.fromARGB(255, 83, 145, 216),
        printerId: 'top-seller',
      ),
      PromoItem(
        title: 'LATEST MODEL',
        startColor: Color.fromARGB(255, 125, 11, 224),
        endColor: Color.fromARGB(255, 134, 36, 219),
        printerId: 'new-arrival',
      ),
      PromoItem(
        title: 'HOLIDAY SALE',
        startColor: Color.fromARGB(255, 255, 0, 0),
        endColor: Color.fromARGB(255, 43, 255, 0),
        printerId: 'holiday-sale',
      ),
    ];

    final pairs = <(PromoItem, Printer)>[];
    for (final promo in promos) {
      final printer = service.findById(promo.printerId);
      if (printer != null) {
        pairs.add((promo, printer));
      }
    }

    return pairs;
  }

  @override
  Widget build(BuildContext context) {
    final printerService = context.watch<PrinterService>();
    final textTheme = Theme.of(context).textTheme;
    final items = _availablePromos(printerService);

    if (items.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 170,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final (promo, printer) = items[index];

          return InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => _showPromoMenu(context, promo, printer),
            child: Container(
              width: 280,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [promo.startColor, promo.endColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      promo.title,
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 30,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showPromoMenu(BuildContext context, PromoItem promo, Printer printer) {
    final cart = context.read<CartService>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      promo.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          printer.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${printer.brand} • ${printer.type}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '\$${printer.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    cart.addItem(printer);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${printer.name} added to cart')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
