import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ExpenseRecordController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance; // Define Firestore instance

  // Method to delete an expense from Firestore
  Future<void> deleteExpense(String docId) async {
    await firestore.collection('expenses').doc(docId).delete();
  }

  // Method to edit an expense
  Future<void> editExpense(String docId, Map<String, dynamic> newData) async {
    await firestore.collection('expenses').doc(docId).update(newData);
  }
}
