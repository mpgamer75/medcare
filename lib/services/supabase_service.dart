import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medcare/config.dart';

class SupabaseService {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      anonKey: AppConfig.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
