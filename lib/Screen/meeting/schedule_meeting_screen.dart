import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoom/color.dart';

class ScheduleMeetingScreen extends StatefulWidget {
  const ScheduleMeetingScreen({super.key});

  @override
  State<ScheduleMeetingScreen> createState() => _ScheduleMeetingScreenState();
}

class _ScheduleMeetingScreenState extends State<ScheduleMeetingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isLoading = false;
  String? _editingDocId;
  Timer? _refreshTimer;

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  Future<void> _saveMeeting() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null || _selectedTime == null) return;

    setState(() => _isLoading = true);

    final user = FirebaseAuth.instance.currentUser;
    final DateTime meetingDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    if (_editingDocId == null) {
      await FirebaseFirestore.instance.collection('meetings').add({
        'title': _titleController.text,
        'host': user?.displayName ?? 'Unknown',
        'email': user?.email,
        'datetime': meetingDateTime,
        'createdAt': Timestamp.now(),
      });
    } else {
      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(_editingDocId)
          .update({
        'title': _titleController.text,
        'datetime': meetingDateTime,
      });
      _editingDocId = null;
    }

    _titleController.clear();
    _selectedDate = null;
    _selectedTime = null;

    setState(() => _isLoading = false);
  }

  void _loadForEdit(String docId, String title, DateTime dateTime) {
    _titleController.text = title;
    _selectedDate = dateTime;
    _selectedTime = TimeOfDay.fromDateTime(dateTime);
    _editingDocId = docId;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("Schedule Meeting", style: TextStyle(color: Colors.black)),
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Meeting Title",
                      labelStyle: const TextStyle(color: Colors.black54),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (val) => val == null || val.isEmpty ? "Enter a title" : null,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _pickDate,
                          child: Text(
                            _selectedDate == null
                                ? "Select Date"
                                : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _pickTime,
                          child: Text(
                            _selectedTime == null
                                ? "Select Time"
                                : _selectedTime!.format(context),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : ElevatedButton.icon(
                    icon: Icon(_editingDocId == null ? Icons.save : Icons.update),
                    label: Text(_editingDocId == null ? "Save Meeting" : "Update Meeting"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: _saveMeeting,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.black26, thickness: 1),
            const SizedBox(height: 10),
            const Text(
              "Scheduled Meetings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('meetings')
                    .orderBy('datetime')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.black));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No meetings scheduled.",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }
                  final meetings = snapshot.data!.docs;
                  final now = DateTime.now();
                  final visibleMeetings = meetings.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final date = (data['datetime'] as Timestamp).toDate();
                    return date.isAfter(now) || date.isAtSameMomentAs(now);
                  }).toList();

                  if (visibleMeetings.isEmpty) {
                    return const Center(
                      child: Text(
                        "No upcoming meetings.",
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: visibleMeetings.length,
                    itemBuilder: (context, index) {
                      final doc = visibleMeetings[index];
                      final data = doc.data() as Map<String, dynamic>;
                      final date = (data['datetime'] as Timestamp).toDate();
                      final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(date);

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['title'],
                                  style: const TextStyle(
                                      color: Colors.black, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "🕒 $formattedDate\n👤 ${data['host']}",
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _loadForEdit(
                                      doc.id,
                                      data['title'],
                                      date,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('meetings')
                                        .doc(doc.id)
                                        .delete();
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
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
