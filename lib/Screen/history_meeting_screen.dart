import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoom/resources/firestore_methods.dart';
import 'package:zoom/color.dart';
import 'meeting_detail_screen.dart';

class HistoryMeetingScreen extends StatelessWidget {
  const HistoryMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirestoreMethods().meetingsHistory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || (snapshot.data! as dynamic).docs.isEmpty) {
          return const Center(
            child: Text(
              "No meetings history yet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: (snapshot.data! as dynamic).docs.length,
          itemBuilder: (context, index) {
            final doc = (snapshot.data! as dynamic).docs[index];
            final meetingName = doc['meetingName'];
            final createdAt = doc['CreatedAt'].toDate();

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MeetingDetailScreen(
                      roomId: meetingName,
                      createdAt: createdAt,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: footerColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.video_call,
                          size: 40, color: buttonColor),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Text(
                          'Room ID: $meetingName',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      const Icon(Icons.arrow_forward_ios,
                          size: 22, color: Colors.black54),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
