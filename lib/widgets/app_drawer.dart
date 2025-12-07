import 'package:flutter/material.dart';

import '../login_page.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatelessWidget{
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 100,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    image: DecorationImage(image: AssetImage('images/my_header_image.png'),
                    fit: BoxFit.fill,
                    ),
                  ),
                  padding: EdgeInsetsGeometry.directional(start: 120, top: 10),
                  child: Text(
                    'Menu',
                    style:TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              ListTile(//home button
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              ListTile( //admin panel
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Admin Panel'),
                onTap: () {
                  Navigator.pop(context);
                  final auth = AuthService();
                  if (auth.isAdmin) {
                    Navigator.pushNamed(context, '/admin');
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(goToAdmin: true),
                      ),
                    );
                  }
                },
              ),
            ],

          ),
    );
  }


}