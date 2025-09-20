import 'package:flutter/material.dart';

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateless Widget'),
      ),
      body: const Center(
        child: Text(
          'This is a basic stateless widget!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}