import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';


class Message {
  final String senderId;
  final String senderEmail;
  final String senderName;
  final String recipient;
  final String text;
  final Timestamp timestamp;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.senderName,
    required this.recipient,
    required this.text,
    required this.timestamp,
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      senderEmail: map['senderEmail'] ?? '',
      senderName: map['senderName'] ?? 'Unknown User',
      recipient: map['recipient'] ?? 'Everyone',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'senderName': senderName,
      'recipient': recipient,
      'text': text,
      'timestamp': timestamp,
    };
  }
}

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> sendMessage(
      String text,
      String recipient,
      {String? senderNameOverride}
      ) async {
    final User? currentUser = _firebaseAuth.currentUser;

    if (currentUser == null && senderNameOverride != "AI Assistant") return;

    final String currentUserId = currentUser?.uid ?? 'AI_SENDER_ID';
    final String currentUserEmail = currentUser?.email ?? "ai@example.com";

    final String actualSenderName;
    if (senderNameOverride != null) {
      actualSenderName = senderNameOverride;
    } else {

      actualSenderName = currentUser?.displayName ??
          (await _firestore.collection('users').doc(currentUserId).get()).data()?['displayName'] ?? "You";
    }

    final Timestamp timestamp = Timestamp.now();

    final String finalRecipient = recipient;

    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      senderName: actualSenderName,
      recipient: finalRecipient,
      text: text,
      timestamp: timestamp,
    );

    await _firestore.collection('chat_messages').add(newMessage.toMap());
  }

  Stream<List<Message>> getMessages() {
    return _firestore
        .collection('chat_messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<String>> getOnlineUserNames() {
    final String? currentUserId = _firebaseAuth.currentUser?.uid;

    return _firestore.collection('users').snapshots().map((snapshot) {
      List<String> userNames = [];

      for (var doc in snapshot.docs) {
        if (doc.id != currentUserId) {
          String? name = doc.data()['displayName'] as String?;
          if (name != null && name.isNotEmpty) {
            userNames.add(name);
          }
        }
      }
      return userNames;
    });
  }
}