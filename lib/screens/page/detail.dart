import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sparkline/sparkline.dart';
import 'package:tradeapp/provider/auth.dart';
import 'package:tradeapp/provider/balanceDatabase.dart';
import 'package:tradeapp/provider/portofolioDatabase.dart';

// ignore: camel_case_types
class stockdetail extends StatefulWidget {
  const stockdetail({super.key, this.saham});

  @override
  // ignore: library_private_types_in_public_api
  _stockdetailState createState() => _stockdetailState();
  // ignore: prefer_typing_uninitialized_variables
  final saham;
}

// ignore: camel_case_types
class _stockdetailState extends State<stockdetail> {
  @override
  void initState() {
    super.initState();
    chart();
  }

  double? balance;
  int? hasil;
  List chart2 = [];
  List<double> chart3 = [];
  List porto = [];

  final AuthService _authService = AuthService();
  Future<void> chart() async {
    var symbol = widget.saham['name'];
    var api = await http.get(Uri.parse(
        // ignore: unnecessary_brace_in_string_interps
        'https://finnhub.io/api/v1/stock/candle?symbol=${symbol}&resolution=M&from=1600651390&to=2021243390&token=cctjuliad3i1e17hs6hgcctjuliad3i1e17hs6i0'));
    if (api.statusCode == 200) {
      var stockapi = jsonDecode(api.body);
      var x = {"data": stockapi['c']};
      chart2 = x['data'];
      for (int i = 0; i < chart2.length; i++) {
        var ubah = double.parse(chart2[i].toString());
        setState(() {
          chart3.add(ubah);
        });
      }
    }
  }

  sellAlertBox(BuildContext context) {
    TextEditingController amount = TextEditingController();
    var code = widget.saham['name'];
    var description = widget.saham['description'];
    var price = widget.saham['price'];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.saham['name']),
            content: TextField(
                controller: amount, keyboardType: TextInputType.number),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < porto.length; i++) {
                      if (porto[i]['code'] == code) {
                        hasil = porto[i]['amount'];
                        break;
                      }
                    }
                    if (hasil != null) {
                      if (hasil! < int.parse(amount.text)) {
                        final snackBar =
                            SnackBar(content: Text('Stock Cuma ada $hasil'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        if (hasil == int.parse(amount.text)) {
                          FirebaseFirestore.instance
                              .collection('portofolio')
                              .where('uid',
                                  isEqualTo: _authService.getCurrentUID())
                              .get()
                              .then((value) {
                            FirebaseFirestore.instance
                                .collection('portofolio')
                                .where('code', isEqualTo: code)
                                .get()
                                .then((value) {
                              for (var element in value.docs) {
                                FirebaseFirestore.instance
                                    .collection('portofolio')
                                    .doc(element.id)
                                    .delete()
                                    .then((value) {});
                              }
                            });
                          });
                        } else {
                          hasil = hasil! - int.parse(amount.text);
                          porto.clear();
                          FirebaseFirestore.instance
                              .collection('portofolio')
                              .where('uid',
                                  isEqualTo: _authService.getCurrentUID())
                              .get()
                              .then((value) {
                            FirebaseFirestore.instance
                                .collection('portofolio')
                                .where('code', isEqualTo: code)
                                .get()
                                .then((value) {
                              for (var element in value.docs) {
                                FirebaseFirestore.instance
                                    .collection('portofolio')
                                    .doc(element.id)
                                    .delete()
                                    .then((value) {
                                  portofolioDatabase().addPortofolio(code,
                                      description, double.parse(price), hasil!);
                                });
                              }
                            });
                          });
                          FirebaseFirestore.instance
                              .collection('balance')
                              .where('uid',
                                  isEqualTo: _authService.getCurrentUID())
                              .get()
                              .then((value) {
                            for (var element in value.docs) {
                              FirebaseFirestore.instance
                                  .collection('balance')
                                  .doc(element.id)
                                  .delete()
                                  .then((value) {
                                balanceDatabase().addBalance(
                                    balance! + int.parse(amount.text) * double.parse(price));
                              });
                            }
                          });
                        }
                      }
                    }
                  });
                  Navigator.pop(context);
                },
                child: const Text('SELL'),
              ),
            ],
          );
        });
  }

  buyAlertBox(BuildContext context) {
    TextEditingController amount = TextEditingController();
    var code = widget.saham['name'];
    var description = widget.saham['description'];
    var price = widget.saham['price'];
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(widget.saham['name']),
            content: TextField(
                controller: amount, keyboardType: TextInputType.number),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    for (int i = 0; i < porto.length; i++) {
                      if (porto[i]['code'] == code) {
                        hasil = porto[i]['amount'];
                        break;
                      }
                    }
                    if (hasil == null) {
                      if (balance == null ||
                          balance! <
                              (int.parse(amount.text) * double.parse(price))) {
                        const snackBar =
                            SnackBar(content: Text('Balance limited'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        portofolioDatabase().addPortofolio(code, description,
                            double.parse(price), int.parse(amount.text));
                        hasil = int.parse(amount.text);

                        FirebaseFirestore.instance
                            .collection('balance')
                            .where('uid',
                                isEqualTo: _authService.getCurrentUID())
                            .get()
                            .then((value) {
                          for (var element in value.docs) {
                            FirebaseFirestore.instance
                                .collection('balance')
                                .doc(element.id)
                                .delete()
                                .then((value) {
                              balanceDatabase().addBalance(balance! -
                                  int.parse(amount.text) * double.parse(price));
                            });
                          }
                        });
                      }
                      Navigator.pop(context);
                      porto.clear();
                    } else {
                      hasil = hasil! + int.parse(amount.text);
                      porto.clear();
                      FirebaseFirestore.instance
                          .collection('portofolio')
                          .where('uid', isEqualTo: _authService.getCurrentUID())
                          .get()
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('portofolio')
                            .where('code', isEqualTo: code)
                            .get()
                            .then((value) {
                          for (var element in value.docs) {
                            FirebaseFirestore.instance
                                .collection('portofolio')
                                .doc(element.id)
                                .delete()
                                .then((value) {
                              portofolioDatabase().addPortofolio(code,
                                  description, double.parse(price), hasil!);
                            });
                          }
                        });
                      });
                      if (balance! <
                          (int.parse(amount.text) * double.parse(price))) {
                        const snackBar =
                            SnackBar(content: Text('Balance limited'));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        FirebaseFirestore.instance
                            .collection('balance')
                            .where('uid',
                                isEqualTo: _authService.getCurrentUID())
                            .get()
                            .then((value) {
                          for (var element in value.docs) {
                            FirebaseFirestore.instance
                                .collection('balance')
                                .doc(element.id)
                                .delete()
                                .then((value) {
                              balanceDatabase().addBalance(balance! -
                                  int.parse(amount.text) * double.parse(price));
                            });
                          }
                        });
                        Navigator.pop(context);
                      }
                    }
                  });
                },
                child: const Text('BUY'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (chart3.isEmpty) {
      return Scaffold(
          appBar: AppBar(title: Text(widget.saham['name'])),
          body: transition());
    } else {
      return Scaffold(
          appBar: AppBar(title: Text(widget.saham['name'])), body: getBody());
    }
  }

  // ignore: missing_return, body_might_complete_normally_nullable
  Widget? transition() {
    setState(() => getBody());
  }

  Widget getBody() {
    FirebaseFirestore.instance
        .collection('portofolio')
        .where('uid', isEqualTo: _authService.getCurrentUID())
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        var x = {
          'amount': doc['amount'],
          'code': doc['code'],
          'price': doc['price']
        };
        porto.add(x);
      }
    });
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
        padding: const EdgeInsets.fromLTRB(30, 50, 30, 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(widget.saham['description'],
                  style: const TextStyle(fontSize: 20)),
            ),
            Container(margin: const EdgeInsets.only(bottom: 10)),
            Align(
              alignment: Alignment.topLeft,
              child: Text(widget.saham['price'],
                  style: const TextStyle(fontSize: 20)),
            ),
            Container(margin: const EdgeInsets.only(bottom: 40)),
            Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
                ),
                child: Sparkline(
                    data: chart3,
                    lineColor: const Color(0xffff6102),
                    pointsMode: PointsMode.all,
                    pointSize: 8.0)),
            Container(margin: const EdgeInsets.only(bottom: 30)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    buyAlertBox(context);
                  },
                  child: const Text(
                    'BUY',
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sellAlertBox(context);
                  },
                  child: const Text('SELL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
