import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Assuming you have 'zoom/color.dart' file with color definitions
import 'package:zoom/color.dart';
// Assuming you have 'about_screen.dart' file
import 'about_screen.dart';



class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  // State variables for preferences
  bool _isAudioOff = false;
  bool _isVideoOff = false; // Video preference added


  @override
  Widget build(BuildContext context) {
    String name = user?.displayName ?? "Guest User";
    String firstLetter = name.isNotEmpty ? name[0].toUpperCase() : "U";

    return Scaffold(
      // Ensure color.dart defines the scaffold background color,
      // otherwise it will be default white
      // backgroundColor: backgroundColor,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // === 1. User Profile Section ===
            Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: buttonColor.withOpacity(0.8),
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Text(
                    firstLetter,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: darkTextColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? "No email connected",
                  style: TextStyle(color: darkTextColor.withOpacity(0.7)),
                ),
                const SizedBox(height: 20),

                // Sign Out Button
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // Assuming you have a route named '/login' defined
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // === 2. App Preferences Card (with Audio & Video Switches) ===
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: footerColor,
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "App Preferences",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: darkTextColor),
                    ),
                    const SizedBox(height: 8),

                    // Audio Switch
                    SwitchListTile(
                      title: Text(
                        "Turn off audio when joining",
                        style: TextStyle(color: darkTextColor),
                      ),
                      activeColor: buttonColor,
                      value: _isAudioOff,
                      onChanged: (val) {
                        setState(() {
                          _isAudioOff = val;
                        });
                      },
                    ),

                    // Divider (The line requested)
                    Divider(
                      color: darkTextColor.withOpacity(0.1),
                      height: 1,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                    ),

                    // Video Switch (New addition)
                    SwitchListTile(
                      title: Text(
                        "Turn off video when joining",
                        style: TextStyle(color: darkTextColor),
                      ),
                      activeColor: buttonColor,
                      value: _isVideoOff,
                      onChanged: (val) {
                        setState(() {
                          _isVideoOff = val;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // === 3. About App Card ===
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: footerColor,
              elevation: 2,
              child: ListTile(
                leading: Icon(Icons.info_outline, color: buttonColor),
                title: Text(
                  "About app",
                  style: TextStyle(color: darkTextColor),
                ),
                trailing: Icon(Icons.arrow_forward_ios, color: darkTextColor.withOpacity(0.7), size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}