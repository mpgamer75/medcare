import 'package:flutter/material.dart';
import 'package:medcare/constants/theme.dart';

class TraitementsScreen extends StatefulWidget {
  const TraitementsScreen({super.key});

  @override
  State<TraitementsScreen> createState() => _TraitementsScreenState();
}

class _TraitementsScreenState extends State<TraitementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Données factices pour les traitements
  final List<Map<String, dynamic>> _treatments = [
    {
      'name': 'Paracétamol',
      'dosage': '1000mg',
      'frequency': '3 fois par jour',
      'time': ['08:00', '14:00', '20:00'],
      'duration': '5 jours',
      'startDate': '10/03/2025',
      'endDate': '15/03/2025',
      'notes': 'Prendre après les repas',
      'isActive': true,
    },
    {
      'name': 'Amoxicilline',
      'dosage': '500mg',
      'frequency': '2 fois par jour',
      'time': ['09:00', '21:00'],
      'duration': '7 jours',
      'startDate': '08/03/2025',
      'endDate': '15/03/2025',
      'notes': 'Prendre avec un verre d\'eau',
      'isActive': true,
    },
    {
      'name': 'Ibuprofène',
      'dosage': '400mg',
      'frequency': 'Si nécessaire',
      'time': ['Au besoin'],
      'duration': 'En cas de douleur',
      'startDate': '05/03/2025',
      'endDate': '20/03/2025',
      'notes': 'Ne pas dépasser 3 comprimés par jour',
      'isActive': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Traitements'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [Tab(text: 'En cours'), Tab(text: 'Historique')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Onglet des traitements actifs
          _buildActiveTreatmentsList(),

          // Onglet des traitements terminés (historique)
          _buildHistoryTreatmentsList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Ouvrir la boîte de dialogue pour ajouter un traitement
          _showAddTreatmentDialog();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.medication),
            label: 'Traitements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Rendez-vous',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 1) {
            // Déjà sur l'écran des traitements
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/rendezvous');
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profil');
          }
        },
      ),
    );
  }

  // Liste des traitements actifs
  Widget _buildActiveTreatmentsList() {
    final activeTreatments = _treatments.where((t) => t['isActive']).toList();

    if (activeTreatments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medication_outlined,
              size: 64,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun traitement en cours',
              style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un traitement'),
              onPressed: () => _showAddTreatmentDialog(),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activeTreatments.length,
      itemBuilder: (context, index) {
        final treatment = activeTreatments[index];
        return _buildTreatmentCard(treatment);
      },
    );
  }

  // Liste de l'historique des traitements
  Widget _buildHistoryTreatmentsList() {
    final historyTreatments = _treatments.where((t) => !t['isActive']).toList();

    if (historyTreatments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun traitement terminé',
              style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: historyTreatments.length,
      itemBuilder: (context, index) {
        final treatment = historyTreatments[index];
        return _buildTreatmentCard(treatment, isHistory: true);
      },
    );
  }

  // Carte pour afficher un traitement
  Widget _buildTreatmentCard(
    Map<String, dynamic> treatment, {
    bool isHistory = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        isHistory
                            ? AppTheme.textSecondary.withOpacity(0.1)
                            : AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medication,
                    color:
                        isHistory
                            ? AppTheme.textSecondary
                            : AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        treatment['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        treatment['dosage'],
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isHistory)
                  Switch(
                    value: treatment['isActive'],
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        treatment['isActive'] = value;
                      });
                    },
                  ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(
                  icon: Icons.access_time,
                  title: 'Fréquence',
                  value: treatment['frequency'],
                ),
                _buildInfoItem(
                  icon: Icons.calendar_today,
                  title: 'Durée',
                  value: treatment['duration'],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Horaires',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  (treatment['time'] as List<String>).map((time) {
                    return Chip(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      label: Text(
                        time,
                        style: TextStyle(
                          color:
                              isHistory
                                  ? AppTheme.textSecondary
                                  : AppTheme.primaryColor,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            if (treatment['notes'] != null &&
                treatment['notes'].isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Notes',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                treatment['notes'],
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isHistory) ...[
                  TextButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Modifier'),
                    onPressed: () {
                      // Fonction pour modifier le traitement
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Supprimer'),
                    onPressed: () {
                      // Fonction pour supprimer le traitement
                      setState(() {
                        _treatments.remove(treatment);
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.error,
                    ),
                  ),
                ] else ...[
                  TextButton.icon(
                    icon: const Icon(Icons.restart_alt_outlined, size: 18),
                    label: const Text('Réactiver'),
                    onPressed: () {
                      setState(() {
                        treatment['isActive'] = true;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Élément d'information pour les cartes de traitement
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  // Boîte de dialogue pour ajouter un nouveau traitement
  void _showAddTreatmentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Ajouter un traitement'),
            content: const SingleChildScrollView(
              child: Text(
                'Formulaire pour ajouter un traitement (à implémenter)',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Logique pour ajouter un traitement
                  Navigator.pop(context);
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
    );
  }
}
