import 'package:flutter/material.dart';
import 'widgets/app_drawer.dart';
import 'widgets/promo_section.dart';
import 'widgets/filters.dart';
import 'widgets/printer_card.dart';
import 'cart_page.dart';
import 'models/printer.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
  
}

class _MyHomePageState extends State<MyHomePage> {

   final List<Printer> allPrinters = [
    Printer(
      name: 'HP LaserJet Pro',
      type: 'Laser',
      onSale: true,
      rating: 4.8,
      price: 199.99,
      image: 'images/printers/canon_inkjet.png',
    ),
    Printer(
      name: 'Canon Office Inkjet',
      type: 'Inkjet',
      onSale: false,
      rating: 4.5,
      price: 129.99,
      image: 'images/printers/canon_inkjet.png',
    ),
    Printer(
      name: 'Epson Dot Matrix',
      type: 'Epson',
      onSale: true,
      rating: 4.9,
      price: 399.99,
      image: 'images/printers/epson_ecotank.png',
    ),
  ];


  Set<String> activeFilters = {};
  late List<Printer> filteredPrinters;

  @override
  void initState() {
    super.initState();
    filteredPrinters = allPrinters;
  }

  void applyFilters(Set<String> filters) {
    setState(() {
      activeFilters = filters;

      if (filters.isEmpty || filters.contains('All Printers')) {
        filteredPrinters = allPrinters;
        return;
      }

        filteredPrinters = allPrinters.where((printer) {
          bool match = true;

          // If a type is selected (Inkjet, Laser, etc.)
          final typeFilters = filters.where((f) =>
              f == 'Inkjet' || f == 'Laser' || f == 'Dot Matrix');

          if (typeFilters.isNotEmpty) {
            match = match && typeFilters.contains(printer.type);
          }

          // If "On Sale" is selected
          if (filters.contains('On Sale')) {
            match = match && printer.onSale;
          }

          // If "Top Rated" is selected
          if (filters.contains('Top Rated')) {
            match = match && printer.rating >= 4.7;
          }

          return match;
        }).toList();
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(), //this is the side menu bar.
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Printer Shop'),
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
            PromoSection(),
            FilterList(onFiltersChanged: applyFilters),

            // Example sections below — you can fill these with product grids/lists later
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Top Printers',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredPrinters.length,
              itemBuilder: (context, index) {
                final p = filteredPrinters[index];
                return PrinterCard(
                  printer: p,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected ${p.name}')),
                    );
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


