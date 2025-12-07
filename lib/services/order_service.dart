import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/order.dart';
import '../models/printer.dart';

class OrderService extends ChangeNotifier {
  final Box _box = Hive.box('orders');
  final List<OrderRecord> _orders = [];

  OrderService() {
    _loadOrders();
  }

  List<OrderRecord> get orders => List.unmodifiable(_orders);

  void recordOrder(
    List<Printer> items, {
    String? user,
    double discount = 0.0,
    String? couponCode,
  }) {
    if (items.isEmpty) return;
    final subtotal = items.fold<double>(0.0, (sum, item) => sum + item.price);
    final total = (subtotal - discount).clamp(0, double.infinity).toDouble();
    final order = OrderRecord(
      user: user,
      placedAt: DateTime.now(),
      subtotal: subtotal,
      discount: discount,
      couponCode: couponCode,
      total: total,
      items: items
          .map(
            (p) => {
              'id': p.id,
              'name': p.name,
              'price': p.price,
              'type': p.type,
              'brand': p.brand,
              'features': p.features.toList(),
            },
          )
          .toList(),
    );

    _orders.insert(0, order);
    _persist();
    notifyListeners();
  }

  void _loadOrders() {
    final stored = _box.get('list');
    if (stored is List) {
      _orders
        ..clear()
        ..addAll(
          stored.map((m) => OrderRecord.fromMap(Map<dynamic, dynamic>.from(m))),
        );
    }
  }

  void _persist() {
    _box.put('list', _orders.map((o) => o.toMap()).toList());
  }
}
