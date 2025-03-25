import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medcare/constants/theme.dart';
import 'package:medcare/screens/ecran_acceuil.dart';
import 'package:medcare/screens/login_screen.dart';
import 'package:medcare/screens/medication_calendar.dart';
import 'package:medcare/screens/profile.dart';
import 'package:medcare/screens/register_screen.dart';
import 'package:medcare/screens/traitements.dart';
import 'package:medcare/services/auth_service.dart';
import 'package:medcare/services/data_service.dart';
import 'package:medcare/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser la localisation pour les dates
  await initializeDateFormatting('fr_FR', null);

  // Configurer le style de la barre d'état
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.backgroundColor,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Orientation préférée
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialiser Supabase
  await SupabaseService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedCare',
      theme: AppTheme.theme,
      initialRoute: AuthService().isAuthenticated ? '/' : '/login',
      routes: {
        '/': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/traitements': (context) => const TraitementsScreen(),
        '/profil': (context) => const ProfilScreen(),
        '/calendrier': (context) => const MedicationCalendarScreen(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DataService().initialize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Erreur: ${snapshot.error}')),
          );
        }

        return const HomeScreen();
      },
    );
  }
}
