import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_service.dart';
import 'ai_service.dart';

const backgroundColor = Color(0xFFF0F4F8);
const buttonColor = Color(0xFF00BCD4);
const footerColor = Colors.white;
const secondaryBackgroundColor = Color(0xFFD9E1E8);
const darkTextColor = Color(0xFF334756);

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AiService _aiService = AiService();
  final User? currentUser = FirebaseAuth.instance.currentUser;

  late String _currentUserName;
  String _selectedRecipient = "Everyone";
  List<String> _activeParticipants = [];

  @override
  void initState() {
    super.initState();
    _currentUserName = currentUser?.displayName ?? "You";
  }

  List<String> _getParticipantList() {
    List<String> list = ["Everyone", "AI Assistant"];

    list.addAll(_activeParticipants.where((name) => name != _currentUserName && name != "AI Assistant"));

    if (list.length == 2 && !_activeParticipants.contains("AI Assistant")) {
      list.add("No one else is here");
    }
    return list;
  }

  void _sendMessage() async {
    final String text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_selectedRecipient == "No one else is here" && _selectedRecipient != "Everyone") {
      _messageController.clear();
      return;
    }

    _messageController.clear();

    if (_selectedRecipient == "AI Assistant") {
      await _chatService.sendMessage(
        text,
        "AI Assistant",
      );

      String aiResponseText = "Fetching response...";

      try {
        aiResponseText = await _aiService.getAiResponse(text);
      } catch (e) {
        aiResponseText = "AI Connection Error: Please check your API key and network connection.";
      }

      await _chatService.sendMessage(
        aiResponseText,
        _currentUserName,
        senderNameOverride: "AI Assistant",
      );

    } else {
      await _chatService.sendMessage(
        text,
        _selectedRecipient,
      );
    }
  }

  Widget _buildMessageList() {
    return StreamBuilder<List<Message>>(
      stream: _chatService.getMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: darkTextColor)));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(buttonColor)));
        }

        final List<Message> messages = snapshot.data!.where((msg) {
          if (msg.recipient == 'Everyone') {
            return true;
          }
          if (msg.senderName == _currentUserName ||
              msg.recipient == _currentUserName ||
              msg.recipient == "AI Assistant" ||
              msg.senderName == "AI Assistant") {
            return true;
          }
          return false;
        }).toList();

        return ListView.builder(
          reverse: true,
          padding: const EdgeInsets.only(bottom: 8),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(messages[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    final bool isMe = message.senderName == _currentUserName;
    final bool isAI = message.senderName == "AI Assistant";
    String recipientLabel = '';

    if (message.recipient != 'Everyone') {
      if (isMe) {
        recipientLabel = ' (to ${message.recipient})';
      } else if (isAI) {
        recipientLabel = ' (to me)';
      } else {
        recipientLabel = ' (privately)';
      }
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? buttonColor.withOpacity(0.8)
              : (isAI ? Colors.blueGrey.shade50 : secondaryBackgroundColor),
          borderRadius: BorderRadius.circular(15).copyWith(
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(15),
            bottomLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              isAI ? "AI Assistant" : '${message.senderName}$recipientLabel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isMe ? Colors.white70 : darkTextColor.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message.text,
              style: TextStyle(
                color: isMe ? Colors.white : darkTextColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                message.timestamp.toDate().toString().substring(11, 16),
                style: TextStyle(
                  fontSize: 10,
                  color: isMe ? Colors.white54 : darkTextColor.withOpacity(0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: _buildMessageList(),
          ),

          StreamBuilder<List<String>>(
            stream: _chatService.getOnlineUserNames(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                _activeParticipants = snapshot.data!;
              } else if (snapshot.hasError) {
                debugPrint('Error fetching participants: ${snapshot.error}');
              }

              List<String> participants = _getParticipantList();

              if (!participants.contains(_selectedRecipient)) {
                _selectedRecipient = "Everyone";
              }

              bool privateChatDisabled = _selectedRecipient == "No one else is here";

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: footerColor,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: secondaryBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedRecipient,
                          icon: Icon(Icons.arrow_drop_down, color: darkTextColor),
                          style: TextStyle(color: darkTextColor, fontSize: 16),
                          dropdownColor: footerColor,
                          isExpanded: true,
                          items: participants.map<DropdownMenuItem<String>>((String value) {
                            bool isAI = value == "AI Assistant";
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value == "Everyone" ? "To: Everyone (Public)" :
                                (isAI ? "To: AI Assistant" :
                                (value == "No one else is here" ? value : "To: $value (Private)")),
                                style: TextStyle(
                                  color: value == "Everyone" ? darkTextColor :
                                  (value == "No one else is here" ? Colors.red : (isAI ? buttonColor : darkTextColor.withOpacity(0.8))),
                                  fontWeight: value == "Everyone" ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null && newValue != _currentUserName) {
                              setState(() {
                                _selectedRecipient = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            enabled: !privateChatDisabled,
                            style: TextStyle(color: privateChatDisabled ? darkTextColor.withOpacity(0.5) : darkTextColor),
                            decoration: InputDecoration(
                              hintText: privateChatDisabled ? "Cannot send private message now" : "Send a message...",
                              hintStyle: TextStyle(color: darkTextColor.withOpacity(0.6)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: secondaryBackgroundColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        const SizedBox(width: 8),

                        Material(
                          color: privateChatDisabled ? buttonColor.withOpacity(0.5) : buttonColor,
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: privateChatDisabled ? null : _sendMessage,
                            borderRadius: BorderRadius.circular(10),
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}