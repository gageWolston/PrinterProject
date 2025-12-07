import 'package:flutter/material.dart';

import '../login_page.dart';
import '../services/auth_service.dart';
import 'orders_page.dart';
import 'printer_management_page.dart';
import 'user_list_page.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    if (!auth.isAdmin) {
      return Scaffold(
        appBar: AppBar(title: const Text('Admin')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const SizedBox(height: 12),
              const Text('Admin access required'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(goToAdmin: true),
                  ),
                ),
                child: const Text('Sign in as Admin'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _AdminTile(
            icon: Icons.print,
            title: 'Manage Printers',
            subtitle: 'Add, remove, and edit printer listings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrinterManagementPage()),
            ),
          ),
          _AdminTile(
            icon: Icons.people,
            title: 'Manage Users',
            subtitle: 'Add new accounts or remove existing users',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UserListPage()),
            ),
          ),
          _AdminTile(
            icon: Icons.receipt_long,
            title: 'Order History',
            subtitle: 'Lookup previous orders and totals',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrdersPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 32),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
