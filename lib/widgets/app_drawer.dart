import 'package:flutter/material.dart';

import '../login_page.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatelessWidget{
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
            children: [
              Container(
                height: 56,
                color: Theme.of(context).colorScheme.primary,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
              Expanded(child: SizedBox()),
              ListTile( //admin credentials
                leading: Icon(Icons.key),
                title: Text('Super Secret Admin Account Info'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Admin Account Info'),
                      content: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Username: Admin'),
                          SizedBox(height: 8),
                          Text('Password: 1234'),
                          SizedBox(height: 12),
                          Text(
                            'For testing only. Do not use these credentials in production.',
                            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (AuthService().isLoggedIn())
                ListTile( //logout button
                  leading: Icon(Icons.logout),
                  title: Text('Logout'),
                  onTap: () {
                    AuthService().logout();
                    Navigator.pop(context);
                  },
                )
              else
                ListTile( //login button
                  leading: Icon(Icons.login),
                  title: Text('Login'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginPage(),
                      ),
                    );
                  },
                ),
            ],
          ),
    );
  }


}