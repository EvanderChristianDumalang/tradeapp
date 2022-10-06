import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class portofolioDatabase {
  final String? uid;
  portofolioDatabase({this.uid});

  final CollectionReference userPortofolio =
      FirebaseFirestore.instance.collection('portofolio');

  Future<void> addPortofolio(
      String code, String description, double price, int amount) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    userPortofolio.add({
      'code': code,
      'description': description,
      'price': price,
      'amount': amount,
      'uid': uid
    });
    return;
  }

  Stream<QuerySnapshot> get portofolio {
    return userPortofolio.snapshots();
  }
}
