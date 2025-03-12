import 'package:flutter/material.dart';

class TraitementsScreen extends StatelessWidget {
  const TraitementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Traitements')),
      body: const Center(
        child: Text('Liste de mes traitements', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
