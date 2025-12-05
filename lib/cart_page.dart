import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'login_page.dart';

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
          ElevatedButton(
            child: const Text('Checkout'),
            onPressed: () {
              if (!auth.isLoggedIn()) {
                // Not logged in → go to login page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => LoginPage(fromCheckout: true)),
                );
              } else {
                // Logged in → finish checkout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checkout complete!')),
                );
                cart.clearCart();
              }
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
