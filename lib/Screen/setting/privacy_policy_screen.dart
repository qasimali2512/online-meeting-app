import 'package:flutter/material.dart';
import 'package:zoom/color.dart';
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Privacy Policy",style: TextStyle(color: Colors.black),),
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "This Privacy Policy explains how we collect, use, and protect your personal data. "
                "We respect your privacy and ensure that your information remains secure. "
                "By using this app, you agree to our privacy terms.",
            style: TextStyle(color: Colors.black, fontSize: 18, height: 1.5),
          ),
        ),
      ),
    );
  }
}
