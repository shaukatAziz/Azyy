import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/chat_controller.dart';

class AdminChatScreen extends StatefulWidget {
  AdminChatScreen({super.key});

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final ChatController controller = Get.put(ChatController());
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? userId = Get.arguments['userId'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue,
              Colors.tealAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("Messages")
                    .where('userId', isEqualTo: userId)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No messages yet.'));
                  }

                  var data = snapshot.data!.docs;

                  return ListView.builder(
                    reverse: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var docsData = data[index];
                      var role = docsData['role'] as String;
                      var chatMessage = docsData['chat'] as String;

                      var timestamp = docsData['timestamp'] as Timestamp?;
                      String formattedTime = '';

                      if (timestamp != null) {
                        formattedTime = DateFormat('hh:mm a').format(timestamp.toDate());
                      }

                      // Align messages based on roles
                      Widget messageWidget = Align(
                        alignment: role == 'admin' ? Alignment.bottomRight : Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: role == 'admin' ? Colors.purple : Colors.black,
                              boxShadow: [
                                BoxShadow(color: Colors.grey, blurRadius: 0.5, spreadRadius: 0.5),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    chatMessage,
                                    style: TextStyle(color: Colors.white), // Text color for admin
                                    maxLines: null,
                                    softWrap: true,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    formattedTime,
                                    style: TextStyle(color: Colors.white, fontSize: 10), // Time color for admin
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );

                      return messageWidget;
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      controller.sendMessage(role: 'admin', userId: userId.toString());
                    },
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
