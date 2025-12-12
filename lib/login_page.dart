import 'package:flutter/material.dart';

import 'home_page.dart';
import 'services/auth_service.dart';
import 'widgets/animated_button.dart';

class LoginPage extends StatefulWidget {
  final bool fromCheckout;
  final bool goToAdmin;
  const LoginPage({super.key, this.fromCheckout = false, this.goToAdmin = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final auth = AuthService();

  bool isRegisterMode = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (auth.isLoggedIn()) {
        if (widget.goToAdmin && !auth.isAdmin) return;

        if (widget.goToAdmin && auth.isAdmin) {
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (widget.fromCheckout && Navigator.canPop(context)) {
          Navigator.pop(context, true);
        } else {
          Navigator.pushReplacement(
            context,
            _slideRoute(const MyHomePage()),
          );
        }
      }
    });
  }

  void submit() {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) return;

    bool success;

    if (isRegisterMode) {
      success = auth.registerUser(username, password);
    } else {
      if (widget.goToAdmin && username != 'Admin') {
        success = false;
      } else {
        success = auth.login(username, password);
      }
    }

    if (!success) {
      return;
    }

    // If coming from checkout → go back
    if (!isRegisterMode && widget.fromCheckout) {
      Navigator.pop(context, true);
      return;
    }

    if (!isRegisterMode && widget.goToAdmin) {
      Navigator.pushReplacementNamed(context, '/admin');
      return;
    }

    // Normal login → go to home
    if (!isRegisterMode) {
      Navigator.pushReplacement(
        context,
        _slideRoute(const MyHomePage()),
      );
      return;
    }

    // Registration successful
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
            AnimatedActionButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(isRegisterMode ? "Register" : "Login"),
            ),
            if (!widget.goToAdmin)
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

Route<T?> _slideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeOutCubic;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(opacity: animation, child: child),
      );
    },
  );
}
