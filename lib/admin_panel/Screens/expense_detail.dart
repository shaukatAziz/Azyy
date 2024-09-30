import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses/admin_panel/Messages/adminchat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../controller/recordController.dart';
class ExpenseDetails extends StatefulWidget {
  const ExpenseDetails({super.key});

  @override
  State<ExpenseDetails> createState() => _ExpenseDetailsState();
}

class _ExpenseDetailsState extends State<ExpenseDetails> {
  final ExpenseRecordController controller = Get.put(ExpenseRecordController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return const Center(child: Text('User is not logged in'));
    }

    String? userId = Get.arguments?['userId'] ?? user.uid;
       print('****************************************************************************');
       print(userId);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Get.to(AdminChatScreen(),arguments:{'userId':userId} ,transition: Transition.leftToRight);
          }, icon: Icon(Icons.message_sharp,color: Colors.white,))
        ],
        title: Text('Expense Details',style: TextStyle(color: Colors.white),
          
        ),

        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.firestore
            .collection('expenses')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("No Data Found"));
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var data = documents[index].data() as Map<String, dynamic>;

              Timestamp? timestamp = data['timestamp'] as Timestamp?;
              String formattedDate = "";

              if (timestamp != null) {
                DateTime dateTime = timestamp.toDate();
                formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.teal, width: 1),
                ),
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListTile(
                  title: Text(
                    data['product'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount: ${data['amount'] ?? ''}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        'Date: $formattedDate',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [




                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
