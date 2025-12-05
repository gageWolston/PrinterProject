import 'package:flutter/material.dart';
import '../models/printer.dart';

class CartService extends ChangeNotifier {
  final List<Printer> _items = [];

  List<Printer> get items => _items;

  void addItem(Printer printer) {
    _items.add(printer);
    notifyListeners();
  }

  void removeItem(Printer printer) {
    _items.remove(printer);
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0, (sum, p) => sum + p.price);
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
