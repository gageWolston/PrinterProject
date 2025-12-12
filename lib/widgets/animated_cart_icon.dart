import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/cart_service.dart';

class AnimatedCartIcon extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedCartIcon({required this.onPressed, super.key});

  @override
  State<AnimatedCartIcon> createState() => _AnimatedCartIconState();
}

class _AnimatedCartIconState extends State<AnimatedCartIcon> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  int _lastCartItemCount = 0;

  late CartService _cartService;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cartService = context.read<CartService>();
      _lastCartItemCount = _cartService.items.length;
      _cartService.addListener(_onCartChanged);
    });
  }

  void _onCartChanged() {
    if (!mounted) return;
    final newCount = _cartService.items.length;
    if (newCount > _lastCartItemCount) {
      _lastCartItemCount = newCount;
      _controller.forward().then((_) => _controller.reverse());
    } else {
      _lastCartItemCount = newCount;
    }
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartService>();
    
    return ScaleTransition(
      scale: _scale,
      child: Stack(
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: widget.onPressed,
          ),
          if (cart.items.isNotEmpty)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  '${cart.items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
