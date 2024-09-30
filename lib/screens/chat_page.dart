import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // Import this for date formatting
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  final ChatController controller = Get.put(ChatController());

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
              Colors.teal,
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
                    .where('userId', isEqualTo: controller.currentUserId)
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
                      var role = docsData['role'];
                      var chatMessage = docsData['chat'];
                      var timestamp = docsData['timestamp'] as Timestamp?;
                      String formattedTime = '';

                      if (timestamp != null) {
                        formattedTime =
                            DateFormat('hh:mm a').format(timestamp.toDate());
                      }

                      Widget messageWidget;

                      if (role == 'user') {
                        messageWidget = Align(
                          alignment: Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 0.5,
                                      spreadRadius: 0.5)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      chatMessage,
                                      style: TextStyle(color: Colors.black54),
                                      maxLines: null,
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        messageWidget = Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.6,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.green,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white,
                                      blurRadius: 0.5,
                                      spreadRadius: 0.5)
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      chatMessage,
                                      style: TextStyle(color: Colors.white),
                                      maxLines: null,
                                      softWrap: true,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      formattedTime,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }

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
                      controller.sendMessage(
                          role: 'user',
                          userId: FirebaseAuth.instance.currentUser!.uid);
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
