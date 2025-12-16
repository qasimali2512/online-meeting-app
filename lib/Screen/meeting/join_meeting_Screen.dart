import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:zoom/color.dart';
import 'package:zoom/resources/auth-method.dart';
import 'package:zoom/resources/jitsi_meet_method.dart';
import 'package:zoom/widgets/meeting_option.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AuthMethods _authMethods = AuthMethods();
  final JitsiMeetMethod _jitsiMeetMethod = JitsiMeetMethod();

  late TextEditingController meetingIdController;
  late TextEditingController nameController;

  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  void initState() {
    super.initState();
    meetingIdController = TextEditingController();
    nameController = TextEditingController(text: "Guest");
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final user = _authMethods.user;
    if (user != null) {
      String name = user.displayName ?? '';
      if (name.isEmpty) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        name = doc.data()?['username'] ?? 'Guest';
      }
      setState(() {
        nameController.text = name;
      });
    }
  }

  @override
  void dispose() {
    meetingIdController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void _joinMeeting() {
    if (meetingIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter Room ID')));
      return;
    }

    _jitsiMeetMethod.createMeeting(
      roomName: meetingIdController.text.trim(),
      isAudioMuted: isAudioMuted,
      isVideoMuted: isVideoMuted,
      username: nameController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        title: const Text(
          'Join a Meeting',
          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: meetingIdController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                fillColor: footerColor,
                filled: true,
                hintText: 'Room ID',
                hintStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                fillColor: footerColor,
                filled: true,
                hintText: 'Your Name',
                hintStyle: const TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _joinMeeting,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Join Meeting',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              child: Column(
                children: [
              DefaultTextStyle(
              style: const TextStyle(color: Colors.black, fontSize: 16),
                 child:  MeetingOption(
                    text: 'Mute Audio',
                    isMute: isAudioMuted,
                    onChange: onAudioMuted,

                  ),
              ),
                DefaultTextStyle(
                  style: const TextStyle(color: Colors.black, fontSize: 16),

                  child:MeetingOption(
                    text: 'Turn off My Video',
                    isMute: isVideoMuted,
                    onChange: onVideoMuted,

                  ),
                ),
        ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onAudioMuted(bool val) {
    setState(() => isAudioMuted = val);
  }

  void onVideoMuted(bool val) {
    setState(() => isVideoMuted = val);
  }
}
