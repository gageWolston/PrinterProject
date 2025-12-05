import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final bool fromCheckout;  
  const LoginPage({super.key, this.fromCheckout = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  bool isRegisterMode = false;

  void submit() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) return;

    bool success;

    if (isRegisterMode) {
      success = auth.registerUser(username, password);
    } else {
      success = auth.login(username, password);
    }

    if (!success) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Login/Register failed")));
      return;
    }

    // If coming from checkout → go back
    if (!isRegisterMode && widget.fromCheckout) {
      Navigator.pop(context);
      return;
    }

    // Normal login → go to home
    if (!isRegisterMode) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    // Registration successful
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Registration complete")));
    setState(() => isRegisterMode = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isRegisterMode ? "Register" : "Login")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submit,
              child: Text(isRegisterMode ? "Register" : "Login"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isRegisterMode = !isRegisterMode;
                });
              },
              child: Text(isRegisterMode
                  ? "Already have an account? Login"
                  : "Need an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
