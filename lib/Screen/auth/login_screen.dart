import 'package:flutter/material.dart';
import 'package:zoom/resources/auth-method.dart';
import 'package:zoom/widgets/custom-button.dart';
import 'package:zoom/color.dart' as myColors;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() => isLoading = true);
    bool res = await _authMethods.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      context,
    );
    setState(() => isLoading = false);

    if (res && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login to your account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: myColors.footerColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: myColors.secondaryBackgroundColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: myColors.buttonColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: _passwordController,
                style: TextStyle(color: Colors.black),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: myColors.footerColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: myColors.secondaryBackgroundColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: myColors.buttonColor, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              CustomButton(
                text: isLoading ? "Loading..." : "Login",
                onPressed: loginUser,
                color: myColors.buttonColor,
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/forgot'),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: myColors.buttonColor),
                ),
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'Sign in with Google',
                onPressed: () async {
                  bool res = await _authMethods.signInWithGoogle(context);
                  if (res && mounted) {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                color: myColors.footerColor,
                textColor: Colors.black87,
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/signup'),
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
