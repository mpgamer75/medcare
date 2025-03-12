import 'package:flutter/material.dart';
import 'package:medcare/screens/profile.dart';
import 'package:medcare/screens/rdv.dart';
import 'package:medcare/screens/traitements.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedCare',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/traitements': (context) => const TraitementsScreen(),
        '/rendezvous': (context) => const RendezvousScreen(),
        '/profil': (context) => const ProfilScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MedCare')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/traitements'),
              icon: const Icon(Icons.medical_services),
              label: const Text('Mes Traitements'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/rendezvous'),
              icon: const Icon(Icons.calendar_today),
              label: const Text('Mes Rendez-vous'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/profil'),
              icon: const Icon(Icons.person),
              label: const Text('Mon Profil'),
            ),
          ],
        ),
      ),
    );
  }
}
