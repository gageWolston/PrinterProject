import 'package:flutter/material.dart';
import 'package:gage_wolston_software_eng_project/admin/user_list_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'services/cart_service.dart';
import 'home_page.dart';
import 'login_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users');   // local db for username + password
  
 runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Printer app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 64, 226)),
      ),
      home: LoginPage(),
      routes: {
        '/home': (_) => MyHomePage(),
        '/admin': (_) => UserListPage(),
      },
    );
  }
}