// lib/services/auth_service.dart
import 'package:medcare/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Singleton pattern
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Inscription d'un nouvel utilisateur
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required DateTime birthdate,
  }) async {
    try {
      // Créer l'utilisateur dans Supabase Auth
      final response = await SupabaseService.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Erreur lors de la création du compte');
      }

      // Créer le profil utilisateur dans la table users
      await SupabaseService.client.from('users').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'birthdate': birthdate.toIso8601String(),
      });

      // Créer les entrées vides pour les relations
      await SupabaseService.client.from('emergency_contacts').insert({
        'user_id': response.user!.id,
        'name': '',
        'relation': '',
        'phone': '',
      });

      await SupabaseService.client.from('doctor_info').insert({
        'user_id': response.user!.id,
        'name': '',
        'specialty': '',
        'phone': '',
        'address': '',
      });
    } catch (e) {
      // Gérer spécifiquement les erreurs de limitation de taux
      if (e.toString().contains(
            'too_many_requests_over_email_send_rate_limit',
          ) ||
          e.toString().contains('429')) {
        throw Exception(
          'Trop de tentatives d\'inscription. Veuillez attendre quelques minutes avant de réessayer.',
        );
      }
      // Rethrow pour les autres erreurs
      rethrow;
    }
  }

  // Connexion d'un utilisateur existant
  Future<void> signIn({
    required String email, // informations requi pour se connecter
    required String password,
  }) async {
    try {
      await SupabaseService.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      if (e.toString().contains('too_many_requests') ||
          e.toString().contains('429')) {
        throw Exception(
          'Trop de tentatives de connexion. Veuillez attendre quelques minutes avant de réessayer.',
        );
      }
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
  }

  // Vérifier si l'utilisateur est connecté
  bool get isAuthenticated => SupabaseService.client.auth.currentUser != null;
}
