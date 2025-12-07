import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'login_page.dart';
import 'checkout_page.dart';
import 'widgets/animated_button.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartService>(context);
    final auth = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final p = cart.items[index];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => cart.removeItem(p),
                  ),
                );
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          AnimatedActionButton(
            child: const Text('Checkout'),
            onPressed: () async {
              if (!auth.isLoggedIn()) {
                final loggedIn = await Navigator.push<bool>(
                  context,
                  _slideRoute(LoginPage(fromCheckout: true)),
                );

                if (loggedIn == true && context.mounted) {
                  Navigator.push(context, _slideRoute(const CheckoutPage()));
                }
              } else {
                Navigator.push(context, _slideRoute(const CheckoutPage()));
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

PageRouteBuilder _slideRoute(Widget page) {
  return PageRouteBuilder(
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
