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

  // Liste des rendez-vous
  List<Appointment> _appointments = [];

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

    // Rendez-vous d'exemple
    _appointments = [
      Appointment(
        id: '1',
        doctorName: 'Dr. Martin',
        specialty: 'Médecin généraliste',
        date: DateTime.now().add(const Duration(days: 3)),
        time: '10:30',
        location: 'Cabinet médical Central',
        address: '15 rue des Lilas, 75001 Paris',
        notes: 'Apporter carnet de vaccination',
        status: AppointmentStatus.upcoming,
      ),
      Appointment(
        id: '2',
        doctorName: 'Dr. Dubois',
        specialty: 'Cardiologue',
        date: DateTime.now().add(const Duration(days: 8)),
        time: '14:15',
        location: 'Hôpital Saint-Pierre',
        address: '25 avenue de la République, 75011 Paris',
        notes: 'Résultats d\'analyse à apporter',
        status: AppointmentStatus.upcoming,
      ),
      Appointment(
        id: '3',
        doctorName: 'Dr. Bernard',
        specialty: 'Dentiste',
        date: DateTime.now().subtract(const Duration(days: 7)),
        time: '09:00',
        location: 'Cabinet dentaire Sourire',
        address: '8 boulevard Haussmann, 75008 Paris',
        notes: '',
        status: AppointmentStatus.completed,
      ),
      Appointment(
        id: '4',
        doctorName: 'Dr. Petit',
        specialty: 'Dermatologue',
        date: DateTime.now().subtract(const Duration(days: 15)),
        time: '16:45',
        location: 'Centre médical Beauté',
        address: '3 rue de Rivoli, 75004 Paris',
        notes: 'Consultation annulée pour cause d\'urgence',
        status: AppointmentStatus.canceled,
      ),
    ];
  }

  // Getters
  User get currentUser => _currentUser;
  List<Treatment> get treatments => _treatments;
  List<Appointment> get appointments => _appointments;

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

  // Méthodes pour les rendez-vous
  List<Appointment> getUpcomingAppointments() {
    return _appointments
        .where((a) => a.status == AppointmentStatus.upcoming)
        .toList();
  }

  List<Appointment> getCompletedAppointments() {
    return _appointments
        .where((a) => a.status == AppointmentStatus.completed)
        .toList();
  }

  List<Appointment> getCanceledAppointments() {
    return _appointments
        .where((a) => a.status == AppointmentStatus.canceled)
        .toList();
  }

  void addAppointment(Appointment appointment) {
    _appointments.add(appointment);
  }

  void updateAppointment(Appointment appointment) {
    final index = _appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      _appointments[index] = appointment;
    }
  }

  void deleteAppointment(String id) {
    _appointments.removeWhere((a) => a.id == id);
  }

  // Méthodes pour l'utilisateur
  void updateUser(User user) {
    _currentUser = user;
  }

  // Méthodes pour filtrer les rendez-vous par date
  List<Appointment> getAppointmentsByDate(DateTime date) {
    return _appointments.where((a) {
      return a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day;
    }).toList();
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

  // Obtenir les rendez-vous d'aujourd'hui
  List<Appointment> getTodayAppointments() {
    return getAppointmentsByDate(DateTime.now());
  }
}
