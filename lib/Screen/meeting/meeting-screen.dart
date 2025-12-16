import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zoom/resources/jitsi_meet_method.dart';
import '../../widgets/home_meeting_button.dart';

class MeetingScreen extends StatelessWidget {
  MeetingScreen({super.key});

  final JitsiMeetMethod _jitsiMeetMethod = JitsiMeetMethod();

  void createNewMeeting() async {
    final Random random = Random();
    String roomName = (random.nextInt(10000000) + 10000000).toString();
    _jitsiMeetMethod.createMeeting(
      roomName: roomName,
      isAudioMuted: true,
      isVideoMuted: true,
    );
  }

  void joinMeeting(BuildContext context) {
    Navigator.pushNamed(context, '/video-call');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 19, bottom: 70, left: 17, right: 17),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160,
                  height: 120,
                  child: HomeMeetingButton(
                    onPressed: createNewMeeting,
                    text: 'New Meeting',
                    icon: Icons.videocam,
                  ),
                ),
                SizedBox(
                  width: 160,
                  height: 120,
                  child: HomeMeetingButton(
                    onPressed: () => joinMeeting(context),
                    text: 'Join Meeting',
                    icon: Icons.add_box_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 160,
                  height: 120,
                  child: HomeMeetingButton(
                    onPressed: () => Navigator.pushNamed(context, '/schedule'),
                    text: 'Schedule',
                    icon: Icons.calendar_today,
                  ),
                ),
                SizedBox(
                  width: 160,
                  height: 120,
                  child: HomeMeetingButton(
                    onPressed: () => Navigator.pushNamed(context, '/share-screen'),
                    text: 'Share Screen',
                    icon: Icons.arrow_upward_rounded,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, right: 22, top: 40),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/teaching.png',
                    height: 150,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Create/Join Meetings with just one click!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
