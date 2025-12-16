import 'package:flutter/material.dart';
import 'package:zoom/color.dart';
class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Terms of Service",style: TextStyle(color: Colors.black),),
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "By using this app, you agree to follow all rules and conditions stated here. "
                "You may not use the app for illegal purposes or violate any policies. "
                "We reserve the right to modify these terms anytime.",
            style: TextStyle(color: Colors.black, fontSize: 18, height: 1.5),
          ),
        ),
      ),
    );
  }
}
