import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcare/constants/theme.dart';
import 'package:medcare/models/models.dart';
import 'package:medcare/services/data_service.dart';
import 'package:table_calendar/table_calendar.dart';

class MedicationCalendarScreen extends StatefulWidget {
  const MedicationCalendarScreen({super.key});

  @override
  State<MedicationCalendarScreen> createState() =>
      _MedicationCalendarScreenState();
}

class _MedicationCalendarScreenState extends State<MedicationCalendarScreen> {
  late final CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  // Service pour récupérer les données
  final DataService _dataService = DataService();

  // Map pour stocker les médicaments par date
  Map<DateTime, List<Treatment>> _treatmentsByDay = {};

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();

    // Initialiser la map des traitements par jour
    _loadTreatmentsByDay();
  }

  // Charger les traitements pour chaque jour
  void _loadTreatmentsByDay() {
    final treatments = _dataService.getActiveTreatments();

    // Réinitialiser la map
    _treatmentsByDay = {};

    // Pour chaque traitement actif
    for (final treatment in treatments) {
      // Calculer tous les jours entre la date de début et la date de fin
      final daysInBetween = _getDaysInBetween(
        treatment.startDate,
        treatment.endDate,
      );

      // Ajouter le traitement à chaque jour concerné
      for (final day in daysInBetween) {
        final normalizedDay = DateTime(day.year, day.month, day.day);

        if (_treatmentsByDay.containsKey(normalizedDay)) {
          _treatmentsByDay[normalizedDay]!.add(treatment);
        } else {
          _treatmentsByDay[normalizedDay] = [treatment];
        }
      }
    }

    setState(() {});
  }

  // Obtenir tous les jours entre deux dates
  List<DateTime> _getDaysInBetween(DateTime startDate, DateTime endDate) {
    final days = <DateTime>[];

    // Normaliser les dates (sans heure/minute/seconde)
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);

    for (var i = 0; i <= end.difference(start).inDays; i++) {
      days.add(start.add(Duration(days: i)));
    }

    return days;
  }

  // Vérifier si un jour contient des médicaments
  bool _hasTreatments(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _treatmentsByDay.containsKey(normalizedDay) &&
        _treatmentsByDay[normalizedDay]!.isNotEmpty;
  }

  // Obtenir les traitements pour un jour spécifique
  List<Treatment> _getTreatmentsForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _treatmentsByDay[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendrier Médical')),
      body: Column(
        children: [
          // Calendrier
          TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 365)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              return _getTreatmentsForDay(day);
            },
            calendarStyle: CalendarStyle(
              markersMaxCount: 3,
              markerDecoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Divider(),

          // Liste des médicaments pour le jour sélectionné
          Expanded(child: _buildTreatmentsList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          _showAddTreatmentDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
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
            Navigator.pushReplacementNamed(context, '/traitements');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/profil');
          }
        },
      ),
    );
  }

  // Construire la liste des médicaments pour le jour sélectionné
  Widget _buildTreatmentsList() {
    final treatmentsForSelectedDay = _getTreatmentsForDay(_selectedDay);

    if (treatmentsForSelectedDay.isEmpty) {
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
              'Aucun médicament pour le ${DateFormat('dd/MM/yyyy').format(_selectedDay)}',
              style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Ajouter un traitement'),
              onPressed: () => _showAddTreatmentDialog(context),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: treatmentsForSelectedDay.length,
      itemBuilder: (context, index) {
        final treatment = treatmentsForSelectedDay[index];
        return _buildTreatmentCard(treatment);
      },
    );
  }

  // Construire une carte pour un médicament
  Widget _buildTreatmentCard(Treatment treatment) {
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
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.medication,
                    color: AppTheme.primaryColor,
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
                        style: TextStyle(color: AppTheme.primaryColor),
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

  // Afficher la boîte de dialogue pour ajouter un traitement
  void _showAddTreatmentDialog(BuildContext context) {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final frequencyController = TextEditingController();
    final durationController = TextEditingController();
    final notesController = TextEditingController();

    DateTime startDate = _selectedDay;
    DateTime endDate = _selectedDay.add(const Duration(days: 7));

    List<String> times = ['08:00'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Ajouter un traitement'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom du médicament *',
                        hintText: 'Ex: Paracétamol',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Dosage *',
                        hintText: 'Ex: 1000mg',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: frequencyController,
                      decoration: const InputDecoration(
                        labelText: 'Fréquence *',
                        hintText: 'Ex: 3 fois par jour',
                      ),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Horaires de prise:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Liste des horaires avec bouton pour ajouter/supprimer
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...times.map((time) {
                          return Chip(
                            label: Text(time),
                            deleteIcon: const Icon(Icons.close, size: 16),
                            onDeleted: () {
                              setState(() {
                                if (times.length > 1) {
                                  times.remove(time);
                                }
                              });
                            },
                          );
                        }).toList(),
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 16),
                          label: const Text('Ajouter'),
                          onPressed: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );

                            if (pickedTime != null) {
                              setState(() {
                                times.add(
                                  '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}',
                                );
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date de début:'),
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                                label: Text(
                                  DateFormat('dd/MM/yyyy').format(startDate),
                                ),
                                onPressed: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: startDate,
                                        firstDate: DateTime.now().subtract(
                                          const Duration(days: 30),
                                        ),
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 365),
                                        ),
                                      );

                                  if (pickedDate != null) {
                                    setState(() {
                                      startDate = pickedDate;
                                      if (startDate.isAfter(endDate)) {
                                        endDate = startDate.add(
                                          const Duration(days: 7),
                                        );
                                      }
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date de fin:'),
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                ),
                                label: Text(
                                  DateFormat('dd/MM/yyyy').format(endDate),
                                ),
                                onPressed: () async {
                                  final DateTime? pickedDate =
                                      await showDatePicker(
                                        context: context,
                                        initialDate: endDate,
                                        firstDate: startDate,
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 365),
                                        ),
                                      );

                                  if (pickedDate != null) {
                                    setState(() {
                                      endDate = pickedDate;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: durationController,
                      decoration: const InputDecoration(
                        labelText: 'Durée (jours, semaines, etc.)',
                        hintText: 'Ex: 7 jours',
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        hintText: 'Ex: Prendre après les repas',
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                  ),
                  onPressed: () {
                    // Valider les champs obligatoires
                    if (nameController.text.isEmpty ||
                        dosageController.text.isEmpty ||
                        frequencyController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Veuillez remplir les champs obligatoires',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      return;
                    }

                    // Créer un nouveau traitement
                    final newTreatment = Treatment(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameController.text,
                      dosage: dosageController.text,
                      frequency: frequencyController.text,
                      times: times,
                      duration:
                          durationController.text.isNotEmpty
                              ? durationController.text
                              : '${endDate.difference(startDate).inDays + 1} jours',
                      startDate: startDate,
                      endDate: endDate,
                      notes: notesController.text,
                      isActive: true,
                    );

                    // Ajouter le traitement
                    _dataService.addTreatment(newTreatment);

                    // Mettre à jour la liste des traitements par jour
                    _loadTreatmentsByDay();

                    // Fermer la boîte de dialogue
                    Navigator.pop(context);

                    // Afficher un message de confirmation
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${newTreatment.name} ajouté avec succès',
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppTheme.success,
                      ),
                    );
                  },
                  child: const Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
