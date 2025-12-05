import 'package:flutter/material.dart';

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
              ListTile(//about section
                leading: Icon(Icons.info),
                title: Text('About'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile( //admin panel
                leading: Icon(Icons.admin_panel_settings),
                title: Text('Admin Panel'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/admin');
                },
              ),
            ],

          ),
    );
  }


}