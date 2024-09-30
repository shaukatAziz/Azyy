import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {

  final TextEditingController messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get currentUserId => _auth.currentUser?.uid ?? '';
  void sendMessage({required String role,required String userId}) async {
    String chatMessage = messageController.text.trim();
    if (chatMessage.isEmpty) {
      Get.snackbar('Error', 'Enter your message');
      return;
    } else {
      Get.snackbar('Message', 'Message sent successfully');
    }
    try {
      // final userId = _auth.currentUser!.uid;
      CollectionReference ref = _firestore.collection('Messages');
      await ref.add({
        'chat': chatMessage,
        'userId': userId,
        'role': role,

        'timestamp': FieldValue.serverTimestamp(),
      });
      messageController.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }
}
