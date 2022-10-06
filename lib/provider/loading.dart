import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: const Center(child: SpinKitFadingCube(color: Colors.cyan, size: 50,),)
    );
  }
}