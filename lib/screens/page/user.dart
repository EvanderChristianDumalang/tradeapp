// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tradeapp/provider/auth.dart';
import 'package:tradeapp/provider/balanceDatabase.dart';

class Users extends StatefulWidget {
  const Users({super.key, this.saham});

  @override
  // ignore: library_private_types_in_public_api
  _UsersState createState() => _UsersState();
  // ignore: prefer_typing_uninitialized_variables
  final saham;
}

class _UsersState extends State<Users> {
  double? balance;
  double? saldo;
  String error = '';
  withdrawAletrBox(BuildContext context) {
    TextEditingController custom = TextEditingController();
    TextEditingController custom1 = TextEditingController();
    TextEditingController custom2 = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Withdraw"),
            content: SingleChildScrollView(
              child: Form(
                  child: Column(children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bank Name:", style: TextStyle(fontSize: 20)),
                ),
                TextField(controller: custom),
                Container(margin: const EdgeInsets.only(bottom: 30)),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bank Account:", style: TextStyle(fontSize: 20)),
                ),
                TextField(
                    controller: custom1, keyboardType: TextInputType.number),
                Container(margin: const EdgeInsets.only(bottom: 30)),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("USD:", style: TextStyle(fontSize: 20)),
                ),
                TextField(
                    controller: custom2, keyboardType: TextInputType.number),
              ])),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  var ubah = double.parse(custom2.text);
                  saldo = balance;
                  if (ubah > saldo!) {
                    const snackBar = SnackBar(content: Text('Balance limited'));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    print("ey");
                  } else {
                    setState(() {
                      FirebaseFirestore.instance
                          .collection('balance')
                          .where('uid', isEqualTo: _authService.getCurrentUID())
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          FirebaseFirestore.instance
                              .collection('balance')
                              .doc(element.id)
                              .delete()
                              .then((value) {
                            balanceDatabase().addBalance(saldo!);
                          });
                        });
                      });
                      saldo = saldo! - ubah;
                      balance = saldo;
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Withdraw'),
              ),
            ],
          );
        });
  }

  depositAlertBox(BuildContext context) {
    TextEditingController custom = TextEditingController();
    TextEditingController custom1 = TextEditingController();
    TextEditingController custom2 = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Deposit"),
            content: SingleChildScrollView(
              child: Form(
                  child: Column(children: [
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bank Name:", style: TextStyle(fontSize: 20)),
                ),
                TextField(controller: custom),
                Container(margin: const EdgeInsets.only(bottom: 30)),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Bank Account:", style: TextStyle(fontSize: 20)),
                ),
                TextField(
                    controller: custom1, keyboardType: TextInputType.number),
                Container(margin: const EdgeInsets.only(bottom: 30)),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Text("USD:", style: TextStyle(fontSize: 20)),
                ),
                TextField(
                    controller: custom2, keyboardType: TextInputType.number),
              ])),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  var ubah = double.parse(custom2.text);
                  saldo = balance;
                  if (saldo == null) {
                    setState(() {
                      saldo = ubah ;
                      balanceDatabase().addBalance(saldo!);
                      balance = saldo;
                    });
                  } else {
                    setState(() {
                      FirebaseFirestore.instance
                          .collection('balance')
                          .where('uid', isEqualTo: _authService.getCurrentUID())
                          .get()
                          .then((value) {
                        value.docs.forEach((element) {
                          FirebaseFirestore.instance
                              .collection('balance')
                              .doc(element.id)
                              .delete()
                              .then((value) {
                            balanceDatabase().addBalance(saldo!);
                          });
                        });
                      });
                      saldo = ubah + saldo!;
                      balance = saldo;
                    });
                  }
                  Navigator.pop(context);
                },
                child: const Text('Deposit'),
              ),
            ],
          );
        });
  }

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Trade App'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Users()),
                ).then((value) => setState(() {}));
              })
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    FirebaseFirestore.instance
        .collection('balance')
        .where('uid', isEqualTo: _authService.getCurrentUID())
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        balance = doc['balance'];
      }
    });

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Center(
          child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where("uid", isEqualTo: _authService.getCurrentUID())
                  .get(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return const CircularProgressIndicator();
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      DocumentSnapshot users = snapshot.data.docs[index];
                      return Column(children: [
                        Image.network(
                          'https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png',
                          width: 170,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            await _authService.signOut();
                          },
                          child: const Text('Log Out'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                depositAlertBox(context);
                              },
                              child: const Text('Deposit'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                withdrawAletrBox(context);
                              },
                              child: const Text('Withdraw'),
                            )
                          ],
                        ),
                        Container(margin: const EdgeInsets.only(bottom: 30)),
                        const Align(
                          alignment: Alignment.topLeft,
                          child: Text("User Info:",
                              style: TextStyle(fontSize: 20)),
                        ),
                        Container(margin: const EdgeInsets.only(bottom: 20)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Nama: " + users['name'],
                              style: const TextStyle(fontSize: 20)),
                        ),
                        Container(margin: const EdgeInsets.only(bottom: 20)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text("Email: " + users['email'],
                              style: const TextStyle(fontSize: 20)),
                        ),
                        Container(margin: const EdgeInsets.only(bottom: 20)),
                        if (balance == null)
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Balance: 0",
                                style: TextStyle(fontSize: 20)),
                          )
                        else
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text("Balance: " + balance.toString(),
                                style: const TextStyle(fontSize: 20)),
                          ),
                      ]);
                    });
              }),
        ),
      ),
    );
  }
}
