import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcare/constants/theme.dart';
import 'package:medcare/models/models.dart';
import 'package:medcare/screens/add_treatment_form.dart';
import 'package:medcare/screens/medication_calendar.dart';
import 'package:medcare/screens/profile.dart' as profile;
import 'package:medcare/screens/traitements.dart';
import 'package:medcare/services/data_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Service pour les données
  final DataService _dataService = DataService();

  // Liste des traitements du jour
  List<Treatment> _todayTreatments = [];

  // Constantes pour les styles et dimensions
  static const double _cardBorderRadius = 12.0;
  static const double _iconSize = 28.0;
  static const double _smallIconSize = 16.0;
  static const double _padding = 16.0;
  static const double _smallPadding = 8.0;

  @override
  void initState() {
    super.initState();
    _loadTodayTreatments();
  }

  // Charger les traitements du jour avec gestion d'erreur
  void _loadTodayTreatments() {
    try {
      _todayTreatments = _dataService.getTodayTreatments();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du chargement des traitements: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('EasyCare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Fonction pour afficher les notifications
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Aucune notification pour le moment'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section de bienvenue
              Text(
                'Bienvenue 👋',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Gérez facilement vos traitements médicaux.',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppTheme.textSecondary),
              ),

              const SizedBox(height: 32),

              // Carte résumé
              _buildSummaryCard(context),

              const SizedBox(height: 24),

              // Section des traitements du jour
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Traitements du jour',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: const Text('Calendrier'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const MedicationCalendarScreen(),
                        ),
                      ).then((_) => _loadTodayTreatments());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Liste des traitements du jour
              _buildTodayTreatmentsList(),

              const SizedBox(height: 24),

              // Section des actions principales
              Text(
                'Actions rapides',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),

              // Cartes d'action
              _buildActionCard(
                context,
                icon: Icons.medication,
                title: 'Mes Traitements',
                subtitle: 'Gérez vos médicaments et suivez vos prises',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TraitementsScreen(),
                      ),
                    ).then((_) => _loadTodayTreatments()),
              ),

              const SizedBox(height: 16),

              _buildActionCard(
                context,
                icon: Icons.person,
                title: 'Mon Profil',
                subtitle: 'Gérez vos informations personnelles et médicales',
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const profile.ProfilScreen(),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AddTreatmentScreen(
                    onTreatmentAdded: _loadTodayTreatments,
                  ),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Traitements',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 0) {
            // Déjà sur l'écran d'accueil
          } else if (index == 1) {
            Navigator.pushNamed(context, '/traitements');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profil');
          }
        },
      ),
    );
  }

  // Carte de résumé avec les indicateurs principaux
  Widget _buildSummaryCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppTheme.primaryGradient,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aujourd\'hui',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getCurrentDate(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSummaryItem(
                  context,
                  icon: Icons.medication,
                  title: _todayTreatments.length.toString(),
                  subtitle: 'Médicaments aujourd\'hui',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Élément résumé (pour la carte principale)
  Widget _buildSummaryItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  // Carte d'action pour les fonctionnalités principales
  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        side: BorderSide(color: AppTheme.textLight.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_cardBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(_padding),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(_smallPadding),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(_cardBorderRadius),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryColor,
                  size: _iconSize,
                ),
              ),
              const SizedBox(width: _padding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.textSecondary,
                size: _smallIconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Liste des traitements du jour
  Widget _buildTodayTreatmentsList() {
    if (_todayTreatments.isEmpty) {
      return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                Icons.medication_outlined,
                size: 48,
                color: AppTheme.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'Aucun médicament pour aujourd\'hui',
                style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Ajouter un traitement'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => AddTreatmentScreen(
                            onTreatmentAdded: _loadTodayTreatments,
                          ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children:
          _todayTreatments
              .map((treatment) => _buildTreatmentItem(treatment))
              .toList(),
    );
  }

  // Élément de traitement pour la liste du jour
  Widget _buildTreatmentItem(Treatment treatment) {
    return Card(
      margin: const EdgeInsets.only(bottom: _smallPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_cardBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(_padding),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(_smallPadding),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(_smallPadding),
              ),
              child: Icon(
                Icons.medication,
                color: AppTheme.primaryColor,
                size: _iconSize,
              ),
            ),
            const SizedBox(width: _padding),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    treatment.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${treatment.dosage} - ${treatment.frequency}',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Horaires',
                  style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 4),
                Text(
                  treatment.times.join(', '),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Récupérer la date actuelle formatée
  String _getCurrentDate() {
    final now = DateTime.now();
    final formatter = DateFormat('EEEE d MMMM yyyy', 'fr_FR');
    return formatter.format(now);
  }
}
