import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  final Box usersBox = Hive.box('users');

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void deleteUser(String username) {
    usersBox.delete(username);
    setState(() {}); // Refresh UI
  }

  void resetPassword(String username) {
    TextEditingController passController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Reset Password for $username'),
          content: TextField(
            controller: passController,
            decoration: InputDecoration(labelText: 'New Password'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPass = passController.text.trim();
                if (newPass.isNotEmpty) {
                  usersBox.put(username, newPass);
                }
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void clearAllUsers() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Clear ALL Users?'),
          content: const Text(
              'This will permanently remove all accounts from the database.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                usersBox.clear();
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = usersBox.keys
        .where((key) => key != '_loggedInUser')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Administration'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: clearAllUsers,
            tooltip: 'Clear ALL Accounts',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add User',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    final user = usernameController.text.trim();
                    final pass = passwordController.text.trim();
                    if (user.isEmpty || pass.isEmpty) return;
                    if (user == 'Admin') return;
                    usersBox.put(user, pass);
                    usernameController.clear();
                    passwordController.clear();
                    setState(() {});
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text('Create User'),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: keys.isEmpty
                ? const Center(child: Text('No users found.'))
                : ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      final username = keys[index] as String;
                      final password = usersBox.get(username);

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text('Username: $username'),
                          subtitle: Text('Password: $password'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: 'Reset Password',
                                icon: const Icon(Icons.lock_reset),
                                onPressed: () => resetPassword(username),
                              ),
                              IconButton(
                                tooltip: 'Delete User',
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteUser(username),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
