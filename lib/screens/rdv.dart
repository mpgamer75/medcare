import 'package:flutter/material.dart';
import 'package:medcare/constants/theme.dart';

class RendezvousScreen extends StatefulWidget {
  const RendezvousScreen({super.key});

  @override
  State<RendezvousScreen> createState() => _RendezvousScreenState();
}

class _RendezvousScreenState extends State<RendezvousScreen> {
  // Jeu de données pour les rendez-vous
  final List<Map<String, dynamic>> _appointments = [
    {
      'doctor': 'Dr. Martin',
      'specialty': 'Médecin généraliste',
      'date': '15/03/2025',
      'time': '10:30',
      'location': 'Cabinet médical Central',
      'address': '15 rue des Lilas, 75001 Paris',
      'notes': 'Apporter carnet de vaccination',
      'status': 'upcoming', // upcoming, completed, canceled
    },
    {
      'doctor': 'Dr. Dubois',
      'specialty': 'Cardiologue',
      'date': '20/03/2025',
      'time': '14:15',
      'location': 'Hôpital Saint-Pierre',
      'address': '25 avenue de la République, 75011 Paris',
      'notes': 'Résultats d\'analyse à apporter',
      'status': 'upcoming',
    },
    {
      'doctor': 'Dr. Bernard',
      'specialty': 'Dentiste',
      'date': '05/03/2025',
      'time': '09:00',
      'location': 'Cabinet dentaire Sourire',
      'address': '8 boulevard Haussmann, 75008 Paris',
      'notes': '',
      'status': 'completed',
    },
    {
      'doctor': 'Dr. Petit',
      'specialty': 'Dermatologue',
      'date': '25/02/2025',
      'time': '16:45',
      'location': 'Centre médical Beauté',
      'address': '3 rue de Rivoli, 75004 Paris',
      'notes': 'Consultation annulée pour cause d\'urgence',
      'status': 'canceled',
    },
  ];

  // Date sélectionnée pour le filtrage
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Rendez-vous'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Fonction pour filtrer les rendez-vous
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec calendrier simplifié
          _buildCalendarHeader(),

          // Liste des rendez-vous
          Expanded(child: _buildAppointmentsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Ouvrir la boîte de dialogue pour ajouter un rendez-vous
          _showAddAppointmentDialog();
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
            Navigator.pushReplacementNamed(context, '/traitements');
          } else if (index == 2) {
            // Déjà sur l'écran des rendez-vous
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profil');
          }
        },
      ),
    );
  }

  // En-tête avec sélection de date simplifiée
  Widget _buildCalendarHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mars 2025',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      // Fonction pour passer au mois précédent
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: AppTheme.textSecondary,
                    ),
                    onPressed: () {
                      // Fonction pour passer au mois suivant
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(7, (index) {
                final day = DateTime.now().add(Duration(days: index - 3));
                final isSelected =
                    day.day == _selectedDate.day &&
                    day.month == _selectedDate.month &&
                    day.year == _selectedDate.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = day;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppTheme.primaryColor
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.textLight,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _getDayName(day.weekday),
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isSelected
                                    ? Colors.white70
                                    : AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          day.day.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  // Liste des rendez-vous
  Widget _buildAppointmentsList() {
    // Filtrer les rendez-vous par date ou autres critères
    final filteredAppointments =
        _appointments.where((appointment) {
          // Simuler un filtrage par date (en pratique, cela serait fait avec de vraies dates DateTime)
          return true; // Pour l'instant, on affiche tous les rendez-vous
        }).toList();

    // Trier par statut : à venir, puis complétés, puis annulés
    filteredAppointments.sort((a, b) {
      final statusOrder = {'upcoming': 0, 'completed': 1, 'canceled': 2};
      return statusOrder[a['status']]!.compareTo(statusOrder[b['status']]!);
    });

    if (filteredAppointments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 64,
              color: AppTheme.textSecondary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucun rendez-vous programmé',
              style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un rendez-vous'),
              onPressed: () => _showAddAppointmentDialog(),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAppointments.length,
      itemBuilder: (context, index) {
        final appointment = filteredAppointments[index];
        return _buildAppointmentCard(appointment);
      },
    );
  }

  // Carte pour afficher un rendez-vous
  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    // Déterminer la couleur et l'icône en fonction du statut
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (appointment['status']) {
      case 'upcoming':
        statusColor = AppTheme.primaryColor;
        statusIcon = Icons.event_available;
        statusText = 'À venir';
        break;
      case 'completed':
        statusColor = AppTheme.success;
        statusIcon = Icons.check_circle;
        statusText = 'Terminé';
        break;
      case 'canceled':
        statusColor = AppTheme.error;
        statusIcon = Icons.cancel;
        statusText = 'Annulé';
        break;
      default:
        statusColor = AppTheme.textSecondary;
        statusIcon = Icons.help;
        statusText = 'Inconnu';
    }

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
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment['doctor'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        appointment['specialty'],
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Chip(
                  backgroundColor: statusColor.withOpacity(0.1),
                  label: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 12),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildAppointmentInfoItem(
                    icon: Icons.calendar_today,
                    title: 'Date',
                    value: appointment['date'],
                  ),
                ),
                Expanded(
                  child: _buildAppointmentInfoItem(
                    icon: Icons.access_time,
                    title: 'Heure',
                    value: appointment['time'],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAppointmentInfoItem(
              icon: Icons.location_on,
              title: 'Lieu',
              value: appointment['location'],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Text(
                appointment['address'],
                style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
              ),
            ),
            if (appointment['notes'] != null &&
                appointment['notes'].isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildAppointmentInfoItem(
                icon: Icons.note,
                title: 'Notes',
                value: appointment['notes'],
              ),
            ],
            if (appointment['status'] == 'upcoming') ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Modifier'),
                    onPressed: () {
                      // Fonction pour modifier le rendez-vous
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    label: const Text('Annuler'),
                    onPressed: () {
                      // Fonction pour annuler le rendez-vous
                      setState(() {
                        appointment['status'] = 'canceled';
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Élément d'information pour les cartes de rendez-vous
  Widget _buildAppointmentInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Obtenir le nom du jour de la semaine
  String _getDayName(int weekday) {
    const dayNames = ['', 'Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    return dayNames[weekday];
  }

  // Boîte de dialogue pour ajouter un nouveau rendez-vous
  void _showAddAppointmentDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Ajouter un rendez-vous'),
            content: const SingleChildScrollView(
              child: Text(
                'Formulaire pour ajouter un rendez-vous (à implémenter)',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Logique pour ajouter un rendez-vous
                  Navigator.pop(context);
                },
                child: const Text('Ajouter'),
              ),
            ],
          ),
    );
  }

  // Boîte de dialogue pour filtrer les rendez-vous
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Filtrer les rendez-vous'),
            content: const SingleChildScrollView(
              child: Text('Options de filtrage (à implémenter)'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Appliquer les filtres
                  Navigator.pop(context);
                },
                child: const Text('Appliquer'),
              ),
            ],
          ),
    );
  }
}
