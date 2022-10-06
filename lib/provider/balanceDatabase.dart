import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class balanceDatabase {

  final String? uid;
  balanceDatabase({this.uid});

  final CollectionReference userBalance = FirebaseFirestore.instance.collection('balance');

  Future <void> addBalance (double balance) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    userBalance.add({'balance':balance, 'uid': uid});
    return; 
  }

  Stream<QuerySnapshot> get portofolio{
    return userBalance.snapshots();
  }
}