import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controller/recordController.dart';

class ExpenseRecord extends StatefulWidget {
  const ExpenseRecord({super.key});

  @override
  State<ExpenseRecord> createState() => _ExpenseRecordState();
}

class _ExpenseRecordState extends State<ExpenseRecord> {
  final ExpenseRecordController controller = Get.put(ExpenseRecordController());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    if (user == null) {
      return const Center(child: Text('User is not logged in'));
    }

    String? userId = Get.arguments?['userId'] ?? user.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Records",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
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
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _showEditDialog(context, documents[index].id, data);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, documents[index].id);
                        },
                      ),
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

  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Expense"),
        content: const Text("Are you sure you want to delete this expense?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteExpense(docId);
              Navigator.pop(context);
              Get.snackbar(
                'Success', 'Expense deleted successfully!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId, Map<String, dynamic> data) {
    TextEditingController productController = TextEditingController(text: data['product']);
    TextEditingController amountController = TextEditingController(text: data['amount'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Expense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: productController,
              decoration: const InputDecoration(labelText: 'Product Name'),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              var newData = {
                'product': productController.text,
                'amount': amountController.text,
              };
              controller.editExpense(docId, newData);
              Navigator.pop(context);
              Get.snackbar(
                'Success', 'Expense updated successfully!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
