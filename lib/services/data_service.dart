// lib/services/data_service.dart
import 'package:medcare/models/models.dart';
import 'package:medcare/models/medical_document.dart';
import 'package:medcare/services/supabase_service.dart';

class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // Données utilisateur en cache
  late User _currentUser;
  List<Treatment> _treatments = [];
  List<MedicalDocument> _documents = [];

  // Initialisation avec les données de Supabase
  Future<void> initialize() async {
    await _loadCurrentUser();
    await _loadTreatments();
    await _loadDocuments();
  }

  // Récupérer l'utilisateur courant
  Future<void> _loadCurrentUser() async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Aucun utilisateur connecté');
    }

    try {
      // Récupérer les informations de base de l'utilisateur
      final userResponse =
          await SupabaseService.client
              .from('users')
              .select()
              .eq('id', userId)
              .maybeSingle(); // Utiliser maybeSingle au lieu de single pour gérer le cas où l'utilisateur n'existe pas

      // Si l'utilisateur n'existe pas encore dans la table users, créer un profil par défaut
      if (userResponse == null) {
        // Créer un profil utilisateur par défaut
        _currentUser = User(
          id: userId,
          name: 'Utilisateur',
          email: SupabaseService.client.auth.currentUser?.email ?? '',
          phone: '',
          birthdate: DateTime.now(),
          height: '',
          weight: '',
          bloodType: '',
          allergies: [],
          chronicDiseases: [],
          emergencyContact: EmergencyContact(name: '', relation: '', phone: ''),
          doctorInfo: DoctorInfo(
            name: '',
            specialty: '',
            phone: '',
            address: '',
          ),
        );

        // Essayer de créer le profil dans la base de données
        try {
          await SupabaseService.client.from('users').insert({
            'id': userId,
            'name': 'Utilisateur',
            'email': SupabaseService.client.auth.currentUser?.email ?? '',
            'birthdate': DateTime.now().toIso8601String(),
          });

          // Créer les entrées vides pour les relations
          await SupabaseService.client.from('emergency_contacts').insert({
            'user_id': userId,
            'name': '',
            'relation': '',
            'phone': '',
          });

          await SupabaseService.client.from('doctor_info').insert({
            'user_id': userId,
            'name': '',
            'specialty': '',
            'phone': '',
            'address': '',
          });
        } catch (e) {
          // Gérer silencieusement l'erreur pour éviter les erreurs d'initialisation
          print('Erreur lors de la création du profil par défaut: $e');
        }

        return;
      }

      // Si on arrive ici, l'utilisateur existe dans la base de données
      // Le reste de votre code existant pour récupérer les allergies, etc.
      List<String> allergies = [];
      List<String> chronicDiseases = [];
      EmergencyContact emergencyContact;
      DoctorInfo doctorInfo;

      try {
        // Récupérer les allergies
        final allergiesResponse = await SupabaseService.client
            .from('allergies')
            .select('name')
            .eq('user_id', userId);
        allergies =
            (allergiesResponse as List)
                .map((a) => a['name'] as String)
                .toList();
      } catch (e) {
        allergies = [];
      }

      try {
        // Récupérer les maladies chroniques
        final diseasesResponse = await SupabaseService.client
            .from('chronic_diseases')
            .select('name')
            .eq('user_id', userId);
        chronicDiseases =
            (diseasesResponse as List).map((d) => d['name'] as String).toList();
      } catch (e) {
        chronicDiseases = [];
      }

      try {
        // Récupérer le contact d'urgence
        final emergencyContactResponse =
            await SupabaseService.client
                .from('emergency_contacts')
                .select()
                .eq('user_id', userId)
                .maybeSingle();

        if (emergencyContactResponse != null) {
          emergencyContact = EmergencyContact(
            name: emergencyContactResponse['name'] ?? '',
            relation: emergencyContactResponse['relation'] ?? '',
            phone: emergencyContactResponse['phone'] ?? '',
          );
        } else {
          // Créer un contact d'urgence vide
          emergencyContact = EmergencyContact(
            name: '',
            relation: '',
            phone: '',
          );
          // Et l'insérer dans la base de données
          await SupabaseService.client.from('emergency_contacts').insert({
            'user_id': userId,
            'name': '',
            'relation': '',
            'phone': '',
          });
        }
      } catch (e) {
        emergencyContact = EmergencyContact(name: '', relation: '', phone: '');
      }

      try {
        // Récupérer les infos du médecin
        final doctorInfoResponse =
            await SupabaseService.client
                .from('doctor_info')
                .select()
                .eq('user_id', userId)
                .maybeSingle();

        if (doctorInfoResponse != null) {
          doctorInfo = DoctorInfo(
            name: doctorInfoResponse['name'] ?? '',
            specialty: doctorInfoResponse['specialty'] ?? '',
            phone: doctorInfoResponse['phone'] ?? '',
            address: doctorInfoResponse['address'] ?? '',
          );
        } else {
          // Créer des infos médecin vides
          doctorInfo = DoctorInfo(
            name: '',
            specialty: '',
            phone: '',
            address: '',
          );
          // Et les insérer dans la base de données
          await SupabaseService.client.from('doctor_info').insert({
            'user_id': userId,
            'name': '',
            'specialty': '',
            'phone': '',
            'address': '',
          });
        }
      } catch (e) {
        doctorInfo = DoctorInfo(
          name: '',
          specialty: '',
          phone: '',
          address: '',
        );
      }

      // Créer l'objet utilisateur
      _currentUser = User(
        id: userId,
        name: userResponse['name'] ?? 'Utilisateur',
        email:
            userResponse['email'] ??
            SupabaseService.client.auth.currentUser?.email ??
            '',
        phone: userResponse['phone'] ?? '',
        birthdate:
            userResponse['birthdate'] != null
                ? DateTime.parse(userResponse['birthdate'])
                : DateTime.now(),
        height: userResponse['height'] ?? '',
        weight: userResponse['weight'] ?? '',
        bloodType: userResponse['blood_type'] ?? '',
        allergies: allergies,
        chronicDiseases: chronicDiseases,
        emergencyContact: emergencyContact,
        doctorInfo: doctorInfo,
      );
    } catch (e) {
      // En cas d'erreur, créer un utilisateur par défaut pour éviter les exceptions
      print('Erreur lors du chargement du profil: $e');
      _currentUser = User(
        id: userId,
        name: 'Utilisateur',
        email: SupabaseService.client.auth.currentUser?.email ?? '',
        phone: '',
        birthdate: DateTime.now(),
        height: '',
        weight: '',
        bloodType: '',
        allergies: [],
        chronicDiseases: [],
        emergencyContact: EmergencyContact(name: '', relation: '', phone: ''),
        doctorInfo: DoctorInfo(name: '', specialty: '', phone: '', address: ''),
      );
    }
  }

  // Récupérer les traitements
  Future<void> _loadTreatments() async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    // Récupérer tous les traitements
    final treatmentsResponse = await SupabaseService.client
        .from('treatments')
        .select()
        .eq('user_id', userId);

    _treatments = [];

    for (final treatmentData in treatmentsResponse) {
      // Récupérer les horaires pour ce traitement
      final timesResponse = await SupabaseService.client
          .from('treatment_times')
          .select('time')
          .eq('treatment_id', treatmentData['id']);

      final List<String> times =
          (timesResponse as List).map((t) => t['time'] as String).toList();

      _treatments.add(
        Treatment(
          id: treatmentData['id'],
          name: treatmentData['name'],
          dosage: treatmentData['dosage'],
          frequency: treatmentData['frequency'],
          times: times,
          duration: treatmentData['duration'],
          startDate: DateTime.parse(treatmentData['start_date']),
          endDate: DateTime.parse(treatmentData['end_date']),
          notes: treatmentData['notes'],
          isActive: treatmentData['is_active'],
        ),
      );
    }
  }

  // Récupérer les documents
  Future<void> _loadDocuments() async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    final documentsResponse = await SupabaseService.client
        .from('medical_documents')
        .select()
        .eq('user_id', userId);

    _documents =
        documentsResponse.map<MedicalDocument>((doc) {
          DocumentType type;
          switch (doc['type']) {
            case 'prescription':
              type = DocumentType.prescription;
              break;
            case 'labResult':
              type = DocumentType.labResult;
              break;
            case 'medicalReport':
              type = DocumentType.medicalReport;
              break;
            case 'imaging':
              type = DocumentType.imaging;
              break;
            default:
              type = DocumentType.other;
          }

          return MedicalDocument(
            id: doc['id'],
            title: doc['title'],
            type: type,
            date: DateTime.parse(doc['date']),
            doctor: doc['doctor'],
            description: doc['description'] ?? '',
            path: doc['file_path'] ?? '',
          );
        }).toList();
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

  Future<void> addTreatment(Treatment treatment) async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    // Ajouter le traitement dans la base de données
    final response =
        await SupabaseService.client
            .from('treatments')
            .insert({
              'user_id': userId,
              'name': treatment.name,
              'dosage': treatment.dosage,
              'frequency': treatment.frequency,
              'duration': treatment.duration,
              'start_date': treatment.startDate.toIso8601String(),
              'end_date': treatment.endDate.toIso8601String(),
              'notes': treatment.notes,
              'is_active': treatment.isActive,
            })
            .select()
            .single();

    // Ajouter les horaires du traitement
    for (final time in treatment.times) {
      await SupabaseService.client.from('treatment_times').insert({
        'treatment_id': response['id'],
        'time': time,
      });
    }

    // Mettre à jour la liste locale
    await _loadTreatments();
  }

  Future<void> updateTreatment(Treatment treatment) async {
    // Mettre à jour le traitement dans la base de données
    await SupabaseService.client
        .from('treatments')
        .update({
          'name': treatment.name,
          'dosage': treatment.dosage,
          'frequency': treatment.frequency,
          'duration': treatment.duration,
          'start_date': treatment.startDate.toIso8601String(),
          'end_date': treatment.endDate.toIso8601String(),
          'notes': treatment.notes,
          'is_active': treatment.isActive,
        })
        .eq('id', treatment.id);

    // Supprimer les anciens horaires
    await SupabaseService.client
        .from('treatment_times')
        .delete()
        .eq('treatment_id', treatment.id);

    // Ajouter les nouveaux horaires
    for (final time in treatment.times) {
      await SupabaseService.client.from('treatment_times').insert({
        'treatment_id': treatment.id,
        'time': time,
      });
    }

    // Mettre à jour la liste locale
    await _loadTreatments();
  }

  Future<void> deleteTreatment(String id) async {
    // Supprimer le traitement (les horaires seront supprimés en cascade)
    await SupabaseService.client.from('treatments').delete().eq('id', id);

    // Mettre à jour la liste locale
    await _loadTreatments();
  }

  // Méthodes pour l'utilisateur
  Future<void> updateUser(User user) async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    // Mettre à jour les informations de base
    await SupabaseService.client
        .from('users')
        .update({
          'name': user.name,
          'email': user.email,
          'phone': user.phone,
          'birthdate': user.birthdate.toIso8601String(),
          'height': user.height,
          'weight': user.weight,
          'blood_type': user.bloodType,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', userId);

    // Mettre à jour le contact d'urgence
    await SupabaseService.client
        .from('emergency_contacts')
        .update({
          'name': user.emergencyContact.name,
          'relation': user.emergencyContact.relation,
          'phone': user.emergencyContact.phone,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);

    // Mettre à jour les informations du médecin
    await SupabaseService.client
        .from('doctor_info')
        .update({
          'name': user.doctorInfo.name,
          'specialty': user.doctorInfo.specialty,
          'phone': user.doctorInfo.phone,
          'address': user.doctorInfo.address,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('user_id', userId);

    // Mettre à jour les allergies (supprimer puis réinsérer)
    await SupabaseService.client
        .from('allergies')
        .delete()
        .eq('user_id', userId);

    for (final allergy in user.allergies) {
      await SupabaseService.client.from('allergies').insert({
        'user_id': userId,
        'name': allergy,
      });
    }

    // Mettre à jour les maladies chroniques (supprimer puis réinsérer)
    await SupabaseService.client
        .from('chronic_diseases')
        .delete()
        .eq('user_id', userId);

    for (final disease in user.chronicDiseases) {
      await SupabaseService.client.from('chronic_diseases').insert({
        'user_id': userId,
        'name': disease,
      });
    }

    // Mettre à jour les données locales
    _currentUser = user;
  }

  // Méthodes pour les documents
  Future<void> addDocument(MedicalDocument document) async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) return;

    // Convertir le type de document en string
    String typeStr;
    switch (document.type) {
      case DocumentType.prescription:
        typeStr = 'prescription';
        break;
      case DocumentType.labResult:
        typeStr = 'labResult';
        break;
      case DocumentType.medicalReport:
        typeStr = 'medicalReport';
        break;
      case DocumentType.imaging:
        typeStr = 'imaging';
        break;
      case DocumentType.other:
        typeStr = 'other';
        break;
    }

    // Ajouter le document dans la base de données
    await SupabaseService.client.from('medical_documents').insert({
      'user_id': userId,
      'title': document.title,
      'type': typeStr,
      'date': document.date.toIso8601String(),
      'doctor': document.doctor,
      'description': document.description,
      'file_path': document.path,
    });

    // Mettre à jour la liste locale
    await _loadDocuments();
  }

  Future<void> updateDocument(MedicalDocument document) async {
    // Convertir le type de document en string
    String typeStr;
    switch (document.type) {
      case DocumentType.prescription:
        typeStr = 'prescription';
        break;
      case DocumentType.labResult:
        typeStr = 'labResult';
        break;
      case DocumentType.medicalReport:
        typeStr = 'medicalReport';
        break;
      case DocumentType.imaging:
        typeStr = 'imaging';
        break;
      case DocumentType.other:
        typeStr = 'other';
        break;
    }

    // Mettre à jour le document dans la base de données
    await SupabaseService.client
        .from('medical_documents')
        .update({
          'title': document.title,
          'type': typeStr,
          'date': document.date.toIso8601String(),
          'doctor': document.doctor,
          'description': document.description,
          'file_path': document.path,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', document.id);

    // Mettre à jour la liste locale
    await _loadDocuments();
  }

  Future<void> deleteDocument(String id) async {
    // Supprimer le document
    await SupabaseService.client
        .from('medical_documents')
        .delete()
        .eq('id', id);

    // Mettre à jour la liste locale
    await _loadDocuments();
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
