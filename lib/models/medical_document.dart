/// Types de documents médicaux
enum DocumentType {
  prescription, // Ordonnance
  labResult, // Résultat d'analyse
  medicalReport, // Compte-rendu médical
  imaging, // Imagerie médicale
  other, // Autre document
}

/// Classe pour représenter un document médical
class MedicalDocument {
  final String id;
  final String title;
  final DocumentType type;
  final DateTime date;
  final String doctor;
  final String description;
  final String path;

  MedicalDocument({
    required this.id,
    required this.title,
    required this.type,
    required this.date,
    required this.doctor,
    required this.description,
    required this.path,
  });

  /// Convertir un objet Map en document médical
  factory MedicalDocument.fromJson(Map<String, dynamic> json) {
    return MedicalDocument(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      type: _parseDocumentType(json['type']),
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      doctor: json['doctor'] ?? '',
      description: json['description'] ?? '',
      path: json['path'] ?? '',
    );
  }

  /// Convertir un document médical en objet Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.toString().split('.').last,
      'date': date.toIso8601String(),
      'doctor': doctor,
      'description': description,
      'path': path,
    };
  }

  /// Créer une copie du document avec des champs mis à jour
  MedicalDocument copyWith({
    String? id,
    String? title,
    DocumentType? type,
    DateTime? date,
    String? doctor,
    String? description,
    String? path,
  }) {
    return MedicalDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      date: date ?? this.date,
      doctor: doctor ?? this.doctor,
      description: description ?? this.description,
      path: path ?? this.path,
    );
  }

  // Fonction utilitaire pour analyser le type de document
  static DocumentType _parseDocumentType(dynamic type) {
    if (type == null) return DocumentType.other;

    if (type is String) {
      try {
        return DocumentType.values.firstWhere(
          (e) =>
              e.toString().split('.').last.toLowerCase() == type.toLowerCase(),
          orElse: () => DocumentType.other,
        );
      } catch (_) {
        return DocumentType.other;
      }
    }

    return DocumentType.other;
  }
}
