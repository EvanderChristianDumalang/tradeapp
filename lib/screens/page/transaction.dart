import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tradeapp/provider/auth.dart';
import 'package:tradeapp/screens/page/detail.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TransactionState createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
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
                  MaterialPageRoute(builder: (context) => const Transaction()),
                ).then((value) => setState(() {}));
              })
        ],
      ),
      body: getBody(),
    );
  }

  List porto = [];
  Widget getBody() {
    final AuthService authService = AuthService();
    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('portofolio')
            .where("uid", isEqualTo: authService.getCurrentUID())
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) return const CircularProgressIndicator();
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                var portofolio = snapshot.data.docs[index];
                var x = {
                  'price': portofolio['price'].toString(),
                  'name': portofolio['code'],
                  'description': portofolio['description'],
                };
                porto.add(x);
                return InkWell(
                    onTap: () {
                      if (porto.isNotEmpty) {
                      }
                      if (porto.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    stockdetail(saham: porto[index])));
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                        height: 100,
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Container(margin: const EdgeInsets.only(top: 10)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(portofolio['code'],
                                      style: const TextStyle(fontSize: 20)),
                                  Text(portofolio['amount'].toString(),
                                      style: const TextStyle(fontSize: 20))
                                ],
                              ),
                              Container(margin: const EdgeInsets.only(top: 10)),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(portofolio['description'],
                                    style: const TextStyle(fontSize: 15)),
                              ),
                            ],
                          ),
                        )));
              });
        });
  }
}
