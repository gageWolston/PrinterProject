import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'services/order_service.dart';
import 'widgets/animated_button.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  bool _isProcessing = false;
  bool _isComplete = false;
  Timer? _timer;
  final TextEditingController _couponController = TextEditingController();
  String? _appliedCoupon;
  double _discountRate = 0.0;
  String? _couponError;

  @override
  void dispose() {
    _timer?.cancel();
    _couponController.dispose();
    super.dispose();
  }

  double _discountAmount(double subtotal) => subtotal * _discountRate;

  void _startCheckout(CartService cart, OrderService orders) {
    final subtotal = cart.totalPrice;
    final discount = _discountAmount(subtotal);

    setState(() {
      _isProcessing = true;
      _isComplete = false;
    });

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isProcessing = false;
        _isComplete = true;
      });
      orders.recordOrder(
        cart.items,
        user: AuthService().loggedInUser,
        discount: discount,
        couponCode: _appliedCoupon,
      );
      cart.clearCart();
    });
  }

  void _applyCoupon(CartService cart) {
    final code = _couponController.text.trim().toUpperCase();
    const coupons = {'SAVE10': 0.10, 'WELCOME5': 0.05};

    if (cart.items.isEmpty) {
      setState(() {
        _couponError = 'Add an item to use a coupon.';
      });
      return;
    }

    if (coupons.containsKey(code)) {
      setState(() {
        _appliedCoupon = code;
        _discountRate = coupons[code]!;
        _couponError = null;
      });
    } else {
      setState(() {
        _appliedCoupon = null;
        _discountRate = 0.0;
        _couponError = 'Invalid coupon code';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);
    final orders = Provider.of<OrderService>(context, listen: false);
    final subtotal = cart.totalPrice;
    final discountAmount = _discountAmount(subtotal);
    final total = (subtotal - discountAmount).clamp(0, double.infinity);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${cart.items.length} item(s)',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: cart.items.isEmpty
                    ? Center(
                        child: Text(
                          _isComplete
                              ? 'Checkout complete! Your items are on the way.'
                              : 'Your cart is empty.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        key: const ValueKey('cartList'),
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final item = cart.items[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle:
                                Text('\$${item.price.toStringAsFixed(2)}'),
                          );
                        },
                      ),
              ),
            ),
            if (!_isComplete)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Promo Code',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _couponController,
                          decoration: const InputDecoration(
                            hintText: 'Enter coupon (e.g. SAVE10)',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed:
                            _isProcessing ? null : () => _applyCoupon(cart),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                  if (_appliedCoupon != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Applied coupon: $_appliedCoupon',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ),
                  if (_couponError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        _couponError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text('\$${subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  if (discountAmount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Discount'),
                          Text('-\$${discountAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedActionButton(
                    onPressed: _isProcessing || cart.items.isEmpty
                        ? null
                        : () => _startCheckout(cart, orders),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 3),
                          )
                        : const Text('Place Order'),
                  ),
                ],
              ),
            if (_isComplete)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Thanks for your purchase!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
