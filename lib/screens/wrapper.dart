import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tradeapp/models/user.dart';
import 'package:tradeapp/screens/auth/authentication.dart';
import 'package:tradeapp/screens/bottomNav.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);

    if (user == null) {
      return const Authenticate();
    } else {
      return const bottomNav();
    }
  }
}
