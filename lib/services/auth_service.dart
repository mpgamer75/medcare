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
    // Créer l'utilisateur dans Supabase Auth
    final response = await SupabaseService.client.auth.signUp(
      email: email,
      password: password,
    );

    if (response.user == null) {
      throw Exception('Erreur lors de la création du compte');
    }

    try {
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
      // En cas d'erreur, supprimer l'utilisateur créé
      await SupabaseService.client.auth.admin.deleteUser(response.user!.id);
      throw Exception('Erreur lors de la création du profil: $e');
    }
  }

  // Connexion d'un utilisateur existant
  Future<void> signIn({
    required String email, // informations requi pour se connecter
    required String password,
  }) async {
    await SupabaseService.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Déconnexion
  Future<void> signOut() async {
    await SupabaseService.client.auth.signOut();
  }

  // Vérifier si l'utilisateur est connecté
  bool get isAuthenticated => SupabaseService.client.auth.currentUser != null;
}
