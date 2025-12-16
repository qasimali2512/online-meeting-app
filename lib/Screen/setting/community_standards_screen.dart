import 'package:flutter/material.dart';
import 'package:zoom/color.dart';
class CommunityStandardsScreen extends StatelessWidget {
  const CommunityStandardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Community Standards",style: TextStyle(color: Colors.black),),
        backgroundColor: backgroundColor,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "We aim to create a safe and respectful environment for all users. "
                "Harassment, hate speech, or abusive behavior will not be tolerated. "
                "Please communicate respectfully and follow our guidelines.",
            style: TextStyle(color: Colors.black, fontSize: 18, height: 1.5),
          ),
        ),
      ),
    );
  }
}
