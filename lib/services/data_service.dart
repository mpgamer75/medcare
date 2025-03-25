import 'package:medcare/models/models.dart';
import 'package:medcare/models/medical_document.dart';

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

  // Liste des documents médicaux
  List<MedicalDocument> _documents = [];

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

    // Documents médicaux d'exemple
    _documents = [
      MedicalDocument(
        id: '1',
        title: 'Ordonnance médicale',
        type: DocumentType.prescription,
        date: DateTime(2025, 2, 15),
        doctor: 'Dr. Bernard Dupont',
        description: 'Renouvellement traitement asthme',
        path: 'assets/documents/ordonnance_20250215.pdf',
      ),
      MedicalDocument(
        id: '2',
        title: 'Analyse de sang',
        type: DocumentType.labResult,
        date: DateTime(2025, 1, 22),
        doctor: 'Laboratoire Central',
        description: 'Bilan sanguin annuel',
        path: 'assets/documents/analyse_sang_20250122.pdf',
      ),
      MedicalDocument(
        id: '3',
        title: 'Compte-rendu consultation cardiologie',
        type: DocumentType.medicalReport,
        date: DateTime(2024, 12, 7),
        doctor: 'Dr. Marie Lambert',
        description: 'Contrôle annuel',
        path: 'assets/documents/cr_cardio_20241207.pdf',
      ),
    ];
  }

  // Getters
  User get currentUser => _currentUser;
  List<Treatment> get treatments => _treatments;
  List<MedicalDocument> get documents => _documents;

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

  // Méthodes pour les documents médicaux
  List<MedicalDocument> getAllDocuments() {
    // Trier par date décroissante (du plus récent au plus ancien)
    final sortedDocs = List<MedicalDocument>.from(_documents);
    sortedDocs.sort((a, b) => b.date.compareTo(a.date));
    return sortedDocs;
  }

  List<MedicalDocument> getDocumentsByType(DocumentType type) {
    return _documents.where((doc) => doc.type == type).toList();
  }

  void addDocument(MedicalDocument document) {
    _documents.add(document);
  }

  void updateDocument(MedicalDocument document) {
    final index = _documents.indexWhere((doc) => doc.id == document.id);
    if (index != -1) {
      _documents[index] = document;
    }
  }

  void deleteDocument(String id) {
    _documents.removeWhere((doc) => doc.id == id);
  }

  // Méthodes pour obtenir les traitements par date
  List<Treatment> getTreatmentsByDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _treatments.where((t) {
      if (!t.isActive) return false;

      final startDate = DateTime(
        t.startDate.year,
        t.startDate.month,
        t.startDate.day,
      );
      final endDate = DateTime(t.endDate.year, t.endDate.month, t.endDate.day);

      return !normalizedDate.isBefore(startDate) &&
          !normalizedDate.isAfter(endDate);
    }).toList();
  }

  // Obtenir les traitements actifs d'aujourd'hui
  List<Treatment> getTodayTreatments() {
    return getTreatmentsByDate(DateTime.now());
  }
}
