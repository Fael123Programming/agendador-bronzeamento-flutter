import 'package:flutter/material.dart';


class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(context) {
    return const Center(child: CircularProgressIndicator(color: Colors.pink,),);
  }
}