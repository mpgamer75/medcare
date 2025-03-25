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

  // Initialiser le DataService si l'utilisateur est connecté
  if (AuthService().isAuthenticated) {
    try {
      await DataService().initialize();
    } catch (e) {
      print('Erreur lors de l\'initialisation du service de données: $e');
    }
  }

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
        '/': (context) => const AuthWrapper(),
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
    // Si l'utilisateur est connecté mais que le DataService n'est pas initialisé
    if (AuthService().isAuthenticated) {
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
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Erreur: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await AuthService().signOut();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text('Se déconnecter'),
                    ),
                  ],
                ),
              ),
            );
          }

          return const HomeScreen();
        },
      );
    }

    // Si l'utilisateur n'est pas connecté
    return const LoginScreen();
  }
}
