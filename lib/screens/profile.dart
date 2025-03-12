import 'package:flutter/material.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil')),
      body: const Center(
        child: Text('Informations de profil', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
