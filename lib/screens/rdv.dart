import 'package:flutter/material.dart';

class RendezvousScreen extends StatelessWidget {
  const RendezvousScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Rendez-vous')),
      body: const Center(
        child: Text('Liste de mes rendez-vous', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
