// Modèles pour les traitements et données utilisateur dans l'application MedCare

/// Classe pour représenter un traitement médical
class Treatment {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final List<String> times;
  final String duration;
  final DateTime startDate;
  final DateTime endDate;
  final String? notes;
  bool isActive;

  Treatment({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.times,
    required this.duration,
    required this.startDate,
    required this.endDate,
    this.notes,
    this.isActive = true,
  });

  /// Convertir un objet Map en traitement
  factory Treatment.fromJson(Map<String, dynamic> json) {
    return Treatment(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      dosage: json['dosage'] ?? '',
      frequency: json['frequency'] ?? '',
      times: List<String>.from(json['times'] ?? []),
      duration: json['duration'] ?? '',
      startDate: DateTime.tryParse(json['startDate'] ?? '') ?? DateTime.now(),
      endDate:
          DateTime.tryParse(json['endDate'] ?? '') ??
          DateTime.now().add(const Duration(days: 7)),
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
    );
  }

  /// Convertir un traitement en objet Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency,
      'times': times,
      'duration': duration,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'notes': notes,
      'isActive': isActive,
    };
  }

  /// Vérifier si le traitement est en cours
  bool get isOngoing {
    final now = DateTime.now();
    return isActive && startDate.isBefore(now) && endDate.isAfter(now);
  }

  /// Vérifier si le traitement est terminé
  bool get isCompleted {
    final now = DateTime.now();
    return endDate.isBefore(now);
  }

  /// Créer une copie du traitement avec des champs mis à jour
  Treatment copyWith({
    String? id,
    String? name,
    String? dosage,
    String? frequency,
    List<String>? times,
    String? duration,
    DateTime? startDate,
    DateTime? endDate,
    String? notes,
    bool? isActive,
  }) {
    return Treatment(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      times: times ?? this.times,
      duration: duration ?? this.duration,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Classe pour représenter un utilisateur
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final DateTime birthdate;
  final String height;
  final String weight;
  final String bloodType;
  final List<String> allergies;
  final List<String> chronicDiseases;
  final EmergencyContact emergencyContact;
  final DoctorInfo doctorInfo;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.birthdate,
    required this.height,
    required this.weight,
    required this.bloodType,
    required this.allergies,
    required this.chronicDiseases,
    required this.emergencyContact,
    required this.doctorInfo,
  });

  /// Convertir un objet Map en utilisateur
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      birthdate: DateTime.tryParse(json['birthdate'] ?? '') ?? DateTime.now(),
      height: json['height'] ?? '',
      weight: json['weight'] ?? '',
      bloodType: json['bloodType'] ?? '',
      allergies: List<String>.from(json['allergies'] ?? []),
      chronicDiseases: List<String>.from(json['chronicDiseases'] ?? []),
      emergencyContact: EmergencyContact.fromJson(
        json['emergencyContact'] ?? {},
      ),
      doctorInfo: DoctorInfo.fromJson(json['doctorInfo'] ?? {}),
    );
  }

  /// Convertir un utilisateur en objet Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'birthdate': birthdate.toIso8601String(),
      'height': height,
      'weight': weight,
      'bloodType': bloodType,
      'allergies': allergies,
      'chronicDiseases': chronicDiseases,
      'emergencyContact': emergencyContact.toJson(),
      'doctorInfo': doctorInfo.toJson(),
    };
  }

  /// Calculer l'âge de l'utilisateur
  int get age {
    final now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  /// Obtenir les initiales du nom de l'utilisateur
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.isEmpty) return '';
    if (nameParts.length == 1) return nameParts[0][0];
    return '${nameParts[0][0]}${nameParts[1][0]}';
  }

  /// Créer une copie de l'utilisateur avec des champs mis à jour
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    DateTime? birthdate,
    String? height,
    String? weight,
    String? bloodType,
    List<String>? allergies,
    List<String>? chronicDiseases,
    EmergencyContact? emergencyContact,
    DoctorInfo? doctorInfo,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthdate: birthdate ?? this.birthdate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      doctorInfo: doctorInfo ?? this.doctorInfo,
    );
  }
}

/// Classe pour représenter un contact d'urgence
class EmergencyContact {
  final String name;
  final String relation;
  final String phone;

  EmergencyContact({
    required this.name,
    required this.relation,
    required this.phone,
  });

  /// Convertir un objet Map en contact d'urgence
  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] ?? '',
      relation: json['relation'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  /// Convertir un contact d'urgence en objet Map
  Map<String, dynamic> toJson() {
    return {'name': name, 'relation': relation, 'phone': phone};
  }
}

/// Classe pour représenter les informations du médecin
class DoctorInfo {
  final String name;
  final String specialty;
  final String phone;
  final String address;

  DoctorInfo({
    required this.name,
    required this.specialty,
    required this.phone,
    required this.address,
  });

  /// Convertir un objet Map en informations du médecin
  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      name: json['name'] ?? '',
      specialty: json['specialty'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
    );
  }

  /// Convertir les informations du médecin en objet Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'specialty': specialty,
      'phone': phone,
      'address': address,
    };
  }
}
