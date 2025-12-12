import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'admin/admin_dashboard_page.dart';
import 'home_page.dart';
import 'services/cart_service.dart';
import 'services/order_service.dart';
import 'services/printer_service.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users'); // local db for username + password
  await Hive.openBox('printers');
  await Hive.openBox('orders');
  
  // Clear login state on app start to ensure fresh login
  final usersBox = Hive.box('users');
  usersBox.delete('_loggedInUser');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => PrinterService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer app',
      theme: AppTheme.light,
      home: const MyHomePage(),
      routes: {
        '/home': (_) => const MyHomePage(),
        '/admin': (_) => const AdminDashboardPage(),
      },
    );
  }
}
