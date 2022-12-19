import 'package:basic_bank_app/Screens/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User extends StatefulWidget {
  User({this.customer_name, this.amount});
  final String customer_name;
  final String amount;
  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  String selectedUser;
  TextEditingController _accountController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Money Transfer",
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.blue.shade400,
              elevation: 12,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "${widget.customer_name}",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                decoration: (BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(20))),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      Text("Loading");
                    } else {
                      List<DropdownMenuItem> users = [];
                      for (int i = 0; i < snapshot.data.docs.length; i++) {
                        DocumentSnapshot snap = snapshot.data.docs[i];
                        users.add(
                          DropdownMenuItem(
                            child: Text(snap.data()["name"]),
                            value: "${snap.data()["name"]}",
                          ),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton(
                            items: users,
                            onChanged: (user) {
                              final snackBar = SnackBar(
                                content: Text("Selected user ${user}"),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                              setState(() {
                                selectedUser = user;
                              });
                            },
                            value: selectedUser,
                            isExpanded: false,
                            hint: Text("Select User"),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                controller: _accountController,
                decoration: InputDecoration(
                  hintText: "To Account Number",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "The search field cannot be empty";
                  }
                  return null;
                }),
            SizedBox(
              height: 30,
            ),
            TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: "Amount",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return "The search field cannot be empty";
                  }
                  return null;
                }),
            SizedBox(
              height: 30,
            ),
            FloatingActionButton(
              // color: Colors.blue.shade400,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Payment(
                              customer_name: widget.customer_name,
                              reciever_name: selectedUser,
                              account: _accountController.text,
                              amount: _amountController.text,
                            )));
              },
//              onPressed: () {
//                for (var i = 0; i < userNames.length; i++) {
//                  if (userNames[i]["Customer Name"] == widget.customer_name) {
//                    userNames[i]['Balance'] =
//                        (int.parse(userNames[i]['Balance']) -
//                                int.parse(_amountController.text))
//                            .toString();
//                  } else if (userNames[i]["Customer Name"] == name) {
//                    userNames[i]["Balance"] =
//                        (int.parse(userNames[i]["Balance"]) +
//                                int.parse(_amountController.text.toString()))
//                            .toString();
//                    print(userNames[i]);
//                  }
//                }
//                Navigator.push(
//                    context,
//                    MaterialPageRoute(
//                        builder: (context) => Payment(
//                              customer_name: widget.customer_name,
//                              reciever_name: name,
//                              account: _accountController.text,
//                              amount: _amountController.text,
//                            )));
//              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  "Transfer",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
