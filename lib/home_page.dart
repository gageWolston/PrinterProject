import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_page.dart';
import 'models/printer.dart';
import 'printer_detail_page.dart';
import 'services/printer_service.dart';
import 'widgets/app_drawer.dart';
import 'widgets/filters.dart';
import 'widgets/printer_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Set<String> activeFilters = {};

  void applyFilters(Set<String> filters) {
    setState(() {
      activeFilters = filters;
    });
  }

  List<Printer> _filteredPrinters(List<Printer> printers) {
    if (activeFilters.isEmpty ||
        (activeFilters.contains('All Printers') && activeFilters.length == 1)) {
      return printers;
    }

    return printers.where((printer) {
      bool match = true;

      final typeFilters = activeFilters.where(
        (f) => f == 'Inkjet' || f == 'Laser' || f == 'Dot Matrix',
      );

      if (typeFilters.isNotEmpty) {
        match = match && typeFilters.contains(printer.type);
      }

      final featureFilters = activeFilters.where(
        (f) =>
            f == 'Color' ||
            f == 'Black & White' ||
            f == 'Fax' ||
            f == 'Copier' ||
            f == 'Scanner',
      );

      if (featureFilters.isNotEmpty) {
        match =
            match && featureFilters.every((feature) => printer.features.contains(feature));
      }

      final brandFilters = activeFilters
          .where((f) => f.startsWith('Brand: '))
          .map((f) => f.replaceFirst('Brand: ', ''));

      if (brandFilters.isNotEmpty) {
        match = match && brandFilters.contains(printer.brand);
      }

      final priceFilters = activeFilters.where(
        (f) =>
            f == 'Budget (<\$200)' ||
            f == 'Midrange (\$200-\$400)' ||
            f == 'Premium (\$400+)',
      );

      if (priceFilters.isNotEmpty) {
        final priceMatch = priceFilters.any((filter) {
          if (filter == 'Budget (<\$200)') return printer.price < 200;
          if (filter == 'Midrange (\$200-\$400)') {
            return printer.price >= 200 && printer.price <= 400;
          }
          if (filter == 'Premium (\$400+)') return printer.price > 400;
          return true;
        });
        match = match && priceMatch;
      }

      if (activeFilters.contains('On Sale')) {
        match = match && printer.onSale;
      }

      return match;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final printers = context.watch<PrinterService>().printers;
    final filteredPrinters = _filteredPrinters(printers);

    return Scaffold(
      drawer: const AppDrawer(), //this is the side menu bar.
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Printer Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FilterList(onFiltersChanged: applyFilters),

            // Example sections below — you can fill these with product grids/lists later
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Top Printers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            if (filteredPrinters.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No printers match the selected filters.'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredPrinters.length,
                itemBuilder: (context, index) {
                  final p = filteredPrinters[index];
                  return PrinterCard(
                    printer: p,
                    onTap: () {
                      Navigator.of(context).push(_slideRoute(
                        PrinterDetailPage(printer: p),
                      ));
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

Route<T?> _slideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutQuad,
        reverseCurve: Curves.easeInQuad,
      );

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
