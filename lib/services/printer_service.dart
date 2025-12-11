import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/printer.dart';

class PrinterService extends ChangeNotifier {
  final Box _box = Hive.box('printers');
  final List<Printer> _printers = [];
  late final List<Printer> _featuredPrinters = [
    Printer(
      id: 'top-seller',
      name: 'HP LaserJet Pro Elite',
      brand: 'HP',
      type: 'Laser',
      onSale: true,
      rating: 4.9,
      price: 229.99,
      description:
          'Our top-selling compact laser with enterprise security and speedy output.',
      highlights: [
        '28 ppm black printing',
        'Self-healing Wi‑Fi with mobile app setup',
        'Includes 2-year extended warranty',
      ],
      features: {
        'Black & White',
        'Copier',
        'Scanner',
      },
    ),
    Printer(
      id: 'new-arrival',
      name: 'Canon Studio Color',
      brand: 'Canon',
      type: 'Inkjet',
      onSale: false,
      rating: 4.7,
      price: 349.99,
      description: 'A fresh arrival with vivid color output and quiet operation.',
      highlights: [
        'Borderless photo printing',
        'Auto-duplex with smart tray detection',
        'Eco mode for reduced ink usage',
      ],
      features: {
        'Color',
        'Scanner',
        'Copier',
      },
    ),
    Printer(id: 'holiday-sale',
     name: 'Epson EcoTank', 
     brand: 'Epson', 
     type: 'Inkjet', 
     onSale: true, 
     rating: 4.8, 
     price: 299.99, 
     description: 'A cost-effective inkjet with refillable tanks and high-volume printing.',
      highlights: [
        'Refillable ink tanks', 
        'High-volume printing', 
        'Low-cost per page'
        ], 
      features: {
        'Color', 
        'Scanner', 
        'Copier', 
        }),
  ];

  PrinterService() {
    _loadPrinters();
  }

  List<Printer> get printers => List.unmodifiable(_printers);

  List<Printer> get featuredPrinters => List.unmodifiable(_featuredPrinters);

  Printer? findById(String id) {
    for (final printer in _printers) {
      if (printer.id == id) return printer;
    }

    for (final printer in _featuredPrinters) {
      if (printer.id == id) return printer;
    }

    return null;
  }

  void addPrinter(Printer printer) {
    _printers.add(printer);
    _persist();
    notifyListeners();
  }

  void removePrinter(String id) {
    _printers.removeWhere((p) => p.id == id);
    _persist();
    notifyListeners();
  }

  void updatePrinter(Printer printer) {
    final index = _printers.indexWhere((p) => p.id == printer.id);
    if (index == -1) return;
    _printers[index] = printer;
    _persist();
    notifyListeners();
  }

  void _loadPrinters() {
    final stored = _box.get('list');
    if (stored is List) {
      _printers
        ..clear()
        ..addAll(
          stored.map((m) => Printer.fromMap(Map<dynamic, dynamic>.from(m))),
        );
    }

    if (_printers.isEmpty) {
      _printers.addAll(_defaultPrinters);
      _persist();
    }
  }

  void _persist() {
    _box.put('list', _printers.map((p) => p.toMap()).toList());
  }

  List<Printer> get _defaultPrinters => [
        Printer(
          name: 'HP LaserJet Pro',
          brand: 'HP',
          type: 'Laser',
          onSale: true,
          rating: 4.8,
          price: 199.99,
          description:
              'A fast and reliable laser printer ideal for home offices and small teams.',
          highlights: [
            '26 ppm black printing',
            'Automatic duplex printing',
            'Built-in Wi‑Fi and mobile printing',
            'Secure PIN release',
          ],
          features: {
            'Black & White',
            'Copier',
            'Scanner',
            'Wireless',
          },
        ),
        Printer(
          name: 'Canon Office Inkjet',
          brand: 'Canon',
          type: 'Inkjet',
          onSale: false,
          rating: 4.5,
          price: 129.99,
          description: 'Vibrant color output with economical cartridges for everyday use.',
          highlights: [
            'Hybrid ink system for crisp text',
            'Voice-activated printing support',
            'Auto document feeder',
          ],
          features: {
            'Color',
            'Scanner',
            'Fax',
            'Wireless',
          },
        ),
        Printer(
          name: 'Epson Dot Matrix',
          brand: 'Epson',
          type: 'Dot Matrix',
          onSale: true,
          rating: 4.9,
          price: 399.99,
          description: 'Industrial-grade dot matrix printer built for continuous forms.',
          highlights: [
            'High-impact 9‑pin printing',
            'Multi-part form support',
            'Rugged build for warehouses',
          ],
          features: {
            'Black & White',
            'Copier',
            'Wired',
          },
        ),
        Printer(
          name: 'Brother OfficeJet Multi',
          brand: 'Brother',
          type: 'Inkjet',
          onSale: true,
          rating: 4.6,
          price: 159.99,
          description:
              'All-in-one inkjet built for small teams with quick scanning and copying.',
          highlights: [
            '35-sheet auto document feeder',
            'Mobile app setup and remote management',
            'Automatic duplex printing',
          ],
          features: {
            'Color',
            'Scanner',
            'Copier',
            'Fax',
            'Wireless',
          },
        ),
        Printer(
          name: 'Xerox WorkCentre Pro',
          brand: 'Xerox',
          type: 'Laser',
          onSale: false,
          rating: 4.4,
          price: 329.99,
          description:
              'Reliable monochrome laser printer with enterprise-ready security.',
          highlights: [
            '38 ppm black printing',
            'Auto-duplex and secure PIN release',
            'Robust toner yield for busy offices',
          ],
          features: {
            'Black & White',
            'Copier',
            'Scanner',
            'Wireless',
          },
        ),
      ];
}
