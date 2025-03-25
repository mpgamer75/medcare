import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcare/constants/theme.dart';
import 'package:medcare/screens/add_treatment_form.dart';
import 'package:medcare/screens/medication_calendar.dart';
import 'package:medcare/services/data_service.dart';
import 'package:medcare/models/models.dart';

class TraitementsScreen extends StatefulWidget {
  const TraitementsScreen({super.key});

  @override
  State<TraitementsScreen> createState() => _TraitementsScreenState();
}

class _TraitementsScreenState extends State<TraitementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Service pour gérer les données
  final DataService _dataService = DataService();

  // Liste des traitements
  List<Treatment> _treatments = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTreatments();
  }

  // Charger les traitements
  void _loadTreatments() {
    _treatments = _dataService.treatments;
    setState(() {});
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
        actions: [
          // Bouton pour accéder au calendrier
          IconButton(
            icon: const Icon(Icons.calendar_month),
            tooltip: 'Calendrier médical',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicationCalendarScreen(),
                ),
              ).then((_) => _loadTreatments());
            },
          ),
        ],
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      AddTreatmentScreen(onTreatmentAdded: _loadTreatments),
            ),
          );
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajouter', style: TextStyle(color: Colors.white)),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (index == 1) {
            // Déjà sur l'écran des traitements
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profil');
          }
        },
      ),
    );
  }

  // Liste des traitements actifs
  Widget _buildActiveTreatmentsList() {
    final activeTreatments = _treatments.where((t) => t.isActive).toList();

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
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
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
                          onTreatmentAdded: _loadTreatments,
                        ),
                  ),
                );
              },
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
    final historyTreatments = _treatments.where((t) => !t.isActive).toList();

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
  Widget _buildTreatmentCard(Treatment treatment, {bool isHistory = false}) {
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
                        treatment.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        treatment.dosage,
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
                    value: treatment.isActive,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      setState(() {
                        // Mettre à jour l'état actif du traitement
                        final updatedTreatment = treatment.copyWith(
                          isActive: value,
                        );
                        _dataService.updateTreatment(updatedTreatment);
                        _loadTreatments();
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
                  value: treatment.frequency,
                ),
                _buildInfoItem(
                  icon: Icons.calendar_today,
                  title: 'Durée',
                  value: treatment.duration,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(
                  icon: Icons.calendar_today,
                  title: 'Date de début',
                  value: DateFormat('dd/MM/yyyy').format(treatment.startDate),
                ),
                const SizedBox(width: 16),
                _buildInfoItem(
                  icon: Icons.calendar_today,
                  title: 'Date de fin',
                  value: DateFormat('dd/MM/yyyy').format(treatment.endDate),
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
                  treatment.times.map((time) {
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
            if (treatment.notes != null && treatment.notes!.isNotEmpty) ...[
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
                treatment.notes!,
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
                      // Afficher le formulaire de modification
                      // (Implémentation future)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Fonctionnalité de modification à venir',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
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
                      // Confirmer la suppression
                      _confirmDeleteTreatment(treatment);
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
                        // Réactiver le traitement
                        final updatedTreatment = treatment.copyWith(
                          isActive: true,
                        );
                        _dataService.updateTreatment(updatedTreatment);
                        _loadTreatments();
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

  // Confirmer la suppression d'un traitement
  void _confirmDeleteTreatment(Treatment treatment) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Supprimer le traitement'),
            content: Text(
              'Êtes-vous sûr de vouloir supprimer le traitement "${treatment.name}" ?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.error,
                ),
                onPressed: () {
                  // Supprimer le traitement
                  _dataService.deleteTreatment(treatment.id);
                  _loadTreatments();

                  // Fermer la boîte de dialogue
                  Navigator.pop(context);

                  // Afficher un message de confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${treatment.name} supprimé'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Supprimer'),
              ),
            ],
          ),
    );
  }
}
