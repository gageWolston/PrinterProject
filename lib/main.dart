import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'admin/admin_dashboard_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'services/cart_service.dart';
import 'services/auth_service.dart';
import 'services/order_service.dart';
import 'services/printer_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users'); // local db for username + password
  await Hive.openBox('printers');
  await Hive.openBox('orders');

  final auth = AuthService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
        ChangeNotifierProvider(create: (_) => PrinterService()),
        ChangeNotifierProvider(create: (_) => OrderService()),
      ],
      child: MyApp(isLoggedIn: auth.isLoggedIn()),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer app',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 64, 226)),
      ),
      home: isLoggedIn ? const MyHomePage() : const LoginPage(),
      routes: {
        '/home': (_) => const MyHomePage(),
        '/admin': (_) => const AdminDashboardPage(),
      },
    );
  }
}
