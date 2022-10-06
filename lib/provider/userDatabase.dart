import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: camel_case_types
class userDatabase {
  final String? uid;
  userDatabase({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUserData(String name, String email) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String uid = auth.currentUser!.uid.toString();
    userCollection.add({'name': name, 'email': email, 'uid': uid});
    return;
  }

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }
}
