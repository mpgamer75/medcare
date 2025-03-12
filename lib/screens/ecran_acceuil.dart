import 'package:flutter/material.dart';
import 'package:medcare/screens/profile.dart';
import 'package:medcare/screens/rdv.dart';
import 'package:medcare/screens/traitements.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'MedCare',
          style: TextStyle(
            color: Colors.teal,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Gérez facilement vos traitements et rendez-vous.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),

            const SizedBox(height: 24),

            //  Boutons d'action
            _buildActionButton(
              context,
              icon: Icons.medical_services,
              title: 'Mes Traitements',
              subtitle: 'Gérez vos traitements en un clic',
              onTap: () {
                // Navigation vers les traitements
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TraitementsScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            _buildActionButton(
              context,
              icon: Icons.event,
              title: 'Mes Rendez-vous',
              subtitle: 'Planifiez et suivez vos consultations',
              onTap: () {
                //  Navigation vers les rdv
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RendezvousScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),

            //  Bouton pour accéder au profil utilisateur
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person, color: Colors.white),
                label: const Text(
                  'Mon Profil',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  Widget personnalisé pour les boutons d'action
  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Colors.teal),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
