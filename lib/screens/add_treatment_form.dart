import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcare/constants/theme.dart';
import 'package:medcare/models/models.dart';
import 'package:medcare/services/data_service.dart';
import 'package:medcare/services/notification_service.dart';

class AddTreatmentScreen extends StatefulWidget {
  final DateTime? initialDate;
  final Function? onTreatmentAdded;

  const AddTreatmentScreen({
    super.key,
    this.initialDate,
    this.onTreatmentAdded,
  });

  @override
  State<AddTreatmentScreen> createState() => _AddTreatmentScreenState();
}

class _AddTreatmentScreenState extends State<AddTreatmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;

  List<String> _times = ['08:00'];

  // Service pour gérer les données
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialDate ?? DateTime.now();
    _endDate = _startDate.add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un traitement'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Information du médicament
              _buildSectionHeader('Informations du médicament'),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du médicament *',
                  hintText: 'Ex: Paracétamol',
                  prefixIcon: Icon(Icons.medication),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du médicament';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage *',
                  hintText: 'Ex: 1000mg',
                  prefixIcon: Icon(Icons.science),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le dosage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Fréquence et horaires
              _buildSectionHeader('Fréquence et horaires'),

              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(
                  labelText: 'Fréquence *',
                  hintText: 'Ex: 3 fois par jour',
                  prefixIcon: Icon(Icons.repeat),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la fréquence';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTimePicker(),
              const SizedBox(height: 24),

              // Durée du traitement
              _buildSectionHeader('Durée du traitement'),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date de début:'),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: _selectStartDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(_startDate),
                                  style: TextStyle(color: AppTheme.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Date de fin:'),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: _selectEndDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppTheme.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('dd/MM/yyyy').format(_endDate),
                                  style: TextStyle(color: AppTheme.textPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Durée (optionnel)',
                  hintText: 'Ex: 7 jours',
                  prefixIcon: Icon(Icons.timelapse),
                ),
              ),
              const SizedBox(height: 24),

              // Notes supplémentaires
              _buildSectionHeader('Notes supplémentaires'),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Ex: Prendre après les repas',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // Bouton de soumission
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Ajouter le traitement',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construire l'en-tête de section
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  // Construire le sélecteur d'horaires
  Widget _buildTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Horaires de prise:'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ..._times.map((time) {
              return Chip(
                label: Text(time),
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                labelStyle: TextStyle(color: AppTheme.primaryColor),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() {
                    if (_times.length > 1) {
                      _times.remove(time);
                    }
                  });
                },
              );
            }).toList(),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Ajouter'),
              backgroundColor: Colors.grey.shade200,
              onPressed: _addTime,
            ),
          ],
        ),
      ],
    );
  }

  // Ajouter un nouvel horaire
  void _addTime() async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (timeOfDay != null) {
      final String formattedTime =
          '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';

      setState(() {
        if (!_times.contains(formattedTime)) {
          _times.add(formattedTime);
          // Trier les horaires
          _times.sort();
        }
      });
    }
  }

  // Sélectionner la date de début
  void _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        // Si la date de fin est avant la date de début, ajuster la date de fin
        if (_endDate.isBefore(_startDate)) {
          _endDate = _startDate.add(const Duration(days: 7));
        }
      });
    }
  }

  // Sélectionner la date de fin
  void _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: AppTheme.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  // Soumettre le formulaire
  void _submitForm() async {
    // Valider le formulaire
    if (_formKey.currentState!.validate()) {
      // Calculer la durée si elle n'est pas spécifiée
      final String duration =
          _durationController.text.isNotEmpty
              ? _durationController.text
              : '${_endDate.difference(_startDate).inDays + 1} jours';

      // Créer un nouveau traitement
      final newTreatment = Treatment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        dosage: _dosageController.text,
        frequency: _frequencyController.text,
        times: _times,
        duration: duration,
        startDate: _startDate,
        endDate: _endDate,
        notes: _notesController.text,
        isActive: true,
      );

      // Ajouter le traitement à la base de données
      _dataService.addTreatment(newTreatment);

      // Appeler le callback si fourni
      if (widget.onTreatmentAdded != null) {
        widget.onTreatmentAdded!();
      }

      // Afficher un message de confirmation et retourner à l'écran précédent
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${newTreatment.name} ajouté avec succès'),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Ajouter une notification pour rappel
      if (_startDate.isAfter(DateTime.now())) {
        try {
          await NotificationService.instance.scheduleAppointmentReminder(
            appointmentId: newTreatment.id,
            title: 'Prise de ${newTreatment.name}',
            date: _startDate,
            doctorName: _dataService.currentUser.doctorInfo.name,
          );
        } catch (e) {
          print('Erreur lors de la planification de la notification: $e');
          // Ne pas bloquer le flux si la notification échoue
        }
      }

      Navigator.of(context).pop();
    }
  }
}
