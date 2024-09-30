import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'expense_detail.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Admin Dashboard',style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: StreamBuilder(
          stream: _firestore.collection("users").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return Center(child: Text("Dont have data"));
            }
            final data = snapshot.data!.docs;
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: data.length,
              itemBuilder: (context, index) {
                var docData = data[index].data() as Map<dynamic, dynamic>;
                String userId = data[index].id;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [

                      Card(


                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.teal)
                            ,
                        ),
                        elevation: 9,
                        child: ListTile(

                          contentPadding: EdgeInsets.all(10),
                          title: Text(docData['name'].toString()),

                          subtitle: Text(docData['phone'].toString()),
                          trailing:Text(docData['email'].toString()),

                             onTap: (){
                                  Get.to(()=>ExpenseDetails(),transition:Transition.leftToRight,duration: Duration(seconds: 1),arguments: {'userId': userId},);
                             },


                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

