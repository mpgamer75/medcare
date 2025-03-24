import 'package:medcare/models/models.dart';

/// Service pour gérer les données de l'application
class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Données utilisateur
  late User _currentUser;

  // Liste des traitements
  List<Treatment> _treatments = [];

  // Initialisation avec des données d'exemple
  void initialize() {
    // Données utilisateur fictives
    _currentUser = User(
      id: '1',
      name: 'Sophie Martin',
      email: 'sophie.martin@example.com',
      phone: '06 12 34 56 78',
      birthdate: DateTime(1985, 5, 15),
      height: '168 cm',
      weight: '65 kg',
      bloodType: 'A+',
      allergies: ['Arachide', 'Pénicilline'],
      chronicDiseases: ['Asthme'],
      emergencyContact: EmergencyContact(
        name: 'Pierre Martin',
        relation: 'Époux',
        phone: '06 87 65 43 21',
      ),
      doctorInfo: DoctorInfo(
        name: 'Dr. Bernard Dupont',
        specialty: 'Médecin généraliste',
        phone: '01 23 45 67 89',
        address: '15 rue des Lilas, 75001 Paris',
      ),
    );

    // Traitements d'exemple
    _treatments = [
      Treatment(
        id: '1',
        name: 'Paracétamol',
        dosage: '1000mg',
        frequency: '3 fois par jour',
        times: ['08:00', '14:00', '20:00'],
        duration: '5 jours',
        startDate: DateTime.now().subtract(const Duration(days: 2)),
        endDate: DateTime.now().add(const Duration(days: 3)),
        notes: 'Prendre après les repas',
        isActive: true,
      ),
      Treatment(
        id: '2',
        name: 'Amoxicilline',
        dosage: '500mg',
        frequency: '2 fois par jour',
        times: ['09:00', '21:00'],
        duration: '7 jours',
        startDate: DateTime.now().subtract(const Duration(days: 4)),
        endDate: DateTime.now().add(const Duration(days: 3)),
        notes: 'Prendre avec un verre d\'eau',
        isActive: true,
      ),
      Treatment(
        id: '3',
        name: 'Ibuprofène',
        dosage: '400mg',
        frequency: 'Si nécessaire',
        times: ['Au besoin'],
        duration: 'En cas de douleur',
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 8)),
        notes: 'Ne pas dépasser 3 comprimés par jour',
        isActive: false,
      ),
    ];
  }

  // Getters
  User get currentUser => _currentUser;
  List<Treatment> get treatments => _treatments;

  // Méthodes pour les traitements
  List<Treatment> getActiveTreatments() {
    return _treatments.where((t) => t.isActive).toList();
  }

  List<Treatment> getInactiveTreatments() {
    return _treatments.where((t) => !t.isActive).toList();
  }

  void addTreatment(Treatment treatment) {
    _treatments.add(treatment);
  }

  void updateTreatment(Treatment treatment) {
    final index = _treatments.indexWhere((t) => t.id == treatment.id);
    if (index != -1) {
      _treatments[index] = treatment;
    }
  }

  void deleteTreatment(String id) {
    _treatments.removeWhere((t) => t.id == id);
  }

  // Méthodes pour l'utilisateur
  void updateUser(User user) {
    _currentUser = user;
  }

  // Méthodes pour obtenir les traitements par date
  List<Treatment> getTreatmentsByDate(DateTime date) {
    return _treatments.where((t) {
      return t.isActive &&
          t.startDate.isBefore(date.add(const Duration(days: 1))) &&
          t.endDate.isAfter(date.subtract(const Duration(days: 1)));
    }).toList();
  }

  // Obtenir les traitements actifs d'aujourd'hui
  List<Treatment> getTodayTreatments() {
    return getTreatmentsByDate(DateTime.now());
  }
}
