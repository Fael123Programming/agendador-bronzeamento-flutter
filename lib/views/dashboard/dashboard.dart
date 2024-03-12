import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: const Center(
          child: Text('Dashboard coming soon...'),
        ),
      ),
    );
  }
}