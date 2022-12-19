import 'package:basic_bank_app/Screens/customer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class AllUsers extends StatefulWidget {
  AllUsers({this.balance, this.customer, this.recevier});
  final String balance;
  final String customer;
  final String recevier;
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  Future getUsers() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('users').get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Customers",
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getUsers(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return ListView(
                      children: snapshot.data.docs.map((snap) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Customer(
                                          customer_name: snap.data()["name"],
                                          address: snap.data()["address"],
                                          phone_number: snap.data()["phone"],
                                          balance: snap.data()["balance"],
                                          account_number:
                                              snap.data()["account"],
                                        )));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text(
                                    snap.data()["name"],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                          "Address: " + snap.data()["address"]),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text("Phone: " + snap.data()["phone"]),
                                    ],
                                  ),
                                  trailing: Text(snap.data()['balance']),
                                  leading: Text(snap.data()['account']),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
