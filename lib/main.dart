import 'package:flutter/material.dart';

void main() {
  runApp(const Repx());
}

class Repx extends StatelessWidget {
  const Repx({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repx',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(title: const Text('Repx')),
        body: Center(
          child: Text('Welcome to Repx!', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
