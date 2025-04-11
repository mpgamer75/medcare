import 'package:medcare/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  static NotificationService? _instance;

  NotificationService._();

  static NotificationService get instance {
    _instance ??= NotificationService._();
    return _instance!;
  }

  /// Envoyer une notification par e-mail pour un rendez-vous
  Future<void> sendAppointmentEmail({
    required String userId,
    required String appointmentTitle,
    required DateTime appointmentDate,
    required String doctorName,
  }) async {
    try {
      await SupabaseService.client.functions.invoke(
        'send-appointment-email',
        body: {
          'userId': userId,
          'appointmentTitle': appointmentTitle,
          'appointmentDate': appointmentDate.toIso8601String(),
          'doctorName': doctorName,
        },
      );
    } catch (e) {
      print('Erreur lors de l\'envoi de l\'e-mail: $e');
      rethrow;
    }
  }

  /// Programmer une notification pour un rendez-vous
  /// Cette méthode pourrait être appelée lors de l'ajout d'un nouveau rendez-vous
  Future<void> scheduleAppointmentReminder({
    required String appointmentId,
    required String title,
    required DateTime date,
    required String doctorName,
  }) async {
    final user = SupabaseService.client.auth.currentUser;
    if (user == null) return;

    // Envoyer un e-mail immédiatement pour confirmer le rendez-vous
    await sendAppointmentEmail(
      userId: user.id,
      appointmentTitle: title,
      appointmentDate: date,
      doctorName: doctorName,
    );

    // La fonction Supabase Edge Function s'occupera des rappels
    try {
      await SupabaseService.client.functions.invoke(
        'schedule-appointment-reminder',
        body: {
          'userId': user.id,
          'appointmentId': appointmentId,
          'title': title,
          'date': date.toIso8601String(),
          'doctorName': doctorName,
        },
      );
    } catch (e) {
      print('Erreur lors de la planification du rappel: $e');
    }
  }
}
