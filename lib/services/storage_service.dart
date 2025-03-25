// lib/services/storage_service.dart
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:medcare/services/supabase_service.dart';

class StorageService {
  // Télécharger un document
  Future<String> uploadDocument(File file, String documentId) async {
    final userId = SupabaseService.client.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('Utilisateur non connecté');
    }

    final fileExt = path.extension(file.path);
    final fileName = '$documentId$fileExt';
    final filePath = 'documents/$userId/$fileName';

    await SupabaseService.client.storage
        .from('medical_documents')
        .upload(filePath, file);

    return filePath;
  }

  // Récupérer l'URL publique d'un document
  Future<String> getDocumentUrl(String filePath) async {
    return SupabaseService.client.storage
        .from('medical_documents')
        .getPublicUrl(filePath);
  }

  // Supprimer un document
  Future<void> deleteDocument(String filePath) async {
    await SupabaseService.client.storage.from('medical_documents').remove([
      filePath,
    ]);
  }
}
