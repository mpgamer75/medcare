import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medcare/constants/theme.dart';
import 'package:medcare/screens/add_treatment_form.dart';
import 'package:medcare/screens/ecran_acceuil.dart';
import 'package:medcare/screens/medication_calendar.dart';
import 'package:medcare/screens/profile.dart';
import 'package:medcare/screens/traitements.dart';
import 'package:medcare/services/data_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialiser la localisation pour les dates
  initializeDateFormatting('fr_FR', null);

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

  // Initialiser les données
  DataService().initialize();

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
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/traitements': (context) => const TraitementsScreen(),
        '/profil': (context) => const ProfilScreen(),
        '/calendrier': (context) => const MedicationCalendarScreen(),
        '/ajouter-traitement': (context) => const AddTreatmentScreen(),
      },
    );
  }
}
