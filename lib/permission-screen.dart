import 'package:flutter/material.dart';
import 'package:zoom/Screen/auth/login_screen.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E71EB),
        title: const Text('Permissions Request'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Icon(Icons.lock_person, size: 90, color: Color(0xFF0E71EB)),
            const SizedBox(height: 25),
            const Text(
              'Allow Access to Continue',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text(
              'Zoom Clone needs access to your Camera, Microphone, and Notifications to provide a full meeting experience.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
            const PermissionTile(
              icon: Icons.videocam_rounded,
              title: 'Camera Access',
              description: 'For video calls and meetings',
            ),
            const SizedBox(height: 16),
            const PermissionTile(
              icon: Icons.mic_rounded,
              title: 'Microphone Access',
              description: 'For audio participation in calls',
            ),
            const SizedBox(height: 16),
            const PermissionTile(
              icon: Icons.notifications_active_rounded,
              title: 'Notifications',
              description: 'To alert you about meetings and messages',
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E71EB),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Allow & Continue',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class PermissionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PermissionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0E71EB), size: 30),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
