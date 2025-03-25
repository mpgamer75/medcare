import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:medcare/main.dart';
import 'package:medcare/models/models.dart';
import 'package:medcare/screens/add_treatment_form.dart';
import 'package:medcare/screens/medication_calendar.dart';
import 'package:medcare/screens/profile.dart';
import 'package:medcare/screens/traitements.dart';
import 'package:medcare/services/data_service.dart';

void main() {
  setUp(() async {
    // Initialiser la localisation pour les dates (nécessaire pour les tests)
    await initializeDateFormatting('fr_FR', null);

    // S'assurer que le DataService est initialisé avant les tests
    DataService().initialize();
  });

  testWidgets('Home screen loads correctly with today\'s medications', (
    WidgetTester tester,
  ) async {
    // 🏁 Lance l'application
    await tester.pumpWidget(const MyApp());

    // ✅ Vérifie la présence du titre "MedCare"
    expect(find.text('MedCare'), findsOneWidget);

    // ✅ Vérifie la présence du texte de bienvenue
    expect(find.text('Bienvenue 👋'), findsOneWidget);

    // ✅ Vérifie la présence du texte d'introduction
    expect(
      find.text('Gérez facilement vos traitements médicaux.'),
      findsOneWidget,
    );

    // ✅ Vérifie la présence du texte pour les traitements du jour
    expect(find.text('Traitements du jour'), findsOneWidget);

    // ✅ Vérifie la présence des boutons d'action
    expect(find.text('Mes Traitements'), findsOneWidget);
    expect(find.text('Mon Profil'), findsOneWidget);

    // ✅ Vérifie la présence du bouton d'accès au calendrier
    expect(find.text('Calendrier'), findsOneWidget);

    // ✅ Vérifie que le bouton de rendez-vous n'existe plus
    expect(find.text('Mes Rendez-vous'), findsNothing);
  });

  testWidgets('Navigation vers TraitementsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le bouton "Mes Traitements"
    await tester.tap(find.text('Mes Traitements'));
    await tester.pumpAndSettle();

    // ✅ Vérifie que TraitementsScreen est affiché après la navigation
    expect(find.byType(TraitementsScreen), findsOneWidget);

    // ✅ Vérifie la présence des onglets
    expect(find.text('En cours'), findsOneWidget);
    expect(find.text('Historique'), findsOneWidget);

    // ✅ Vérifie la présence du bouton pour accéder au calendrier
    expect(find.byIcon(Icons.calendar_month), findsOneWidget);
  });

  testWidgets('Navigation vers ProfilScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le bouton "Mon Profil"
    await tester.tap(find.text('Mon Profil'));
    await tester.pumpAndSettle();

    // ✅ Vérifie que ProfilScreen est affiché après la navigation
    expect(find.byType(ProfilScreen), findsOneWidget);

    // ✅ Vérifie la présence des sections du profil
    expect(find.text('Informations personnelles'), findsOneWidget);
    expect(find.text('Informations médicales'), findsOneWidget);
    expect(find.text('Mes documents médicaux'), findsOneWidget);
    expect(find.text('Contact d\'urgence'), findsOneWidget);
    expect(find.text('Mon médecin traitant'), findsOneWidget);
  });

  testWidgets('Navigation vers MedicationCalendarScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le bouton "Calendrier"
    await tester.tap(find.text('Calendrier'));
    await tester.pumpAndSettle();

    // ✅ Vérifie que MedicationCalendarScreen est affiché après la navigation
    expect(find.byType(MedicationCalendarScreen), findsOneWidget);

    // ✅ Vérifie la présence du titre
    expect(find.text('Calendrier Médical'), findsOneWidget);
  });

  testWidgets('BottomNavigationBar contient 3 éléments', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Vérifie que la BottomNavigationBar contient 3 éléments
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    final bottomNavBar = tester.widget<BottomNavigationBar>(
      find.byType(BottomNavigationBar),
    );
    expect(bottomNavBar.items.length, 3);

    // Vérifie que les éléments sont Accueil, Traitements et Profil
    expect(bottomNavBar.items[0].label, 'Accueil');
    expect(bottomNavBar.items[1].label, 'Traitements');
    expect(bottomNavBar.items[2].label, 'Profil');
  });

  testWidgets('FloatingActionButton permet d\'ajouter un traitement', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le FloatingActionButton
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // ✅ Vérifie que l'écran d'ajout de traitement est affiché
    expect(find.byType(AddTreatmentScreen), findsOneWidget);
    expect(find.text('Ajouter un traitement'), findsOneWidget);

    // ✅ Vérifie la présence des champs du formulaire
    expect(find.text('Informations du médicament'), findsOneWidget);
    expect(find.text('Fréquence et horaires'), findsOneWidget);
    expect(find.text('Durée du traitement'), findsOneWidget);
  });

  testWidgets('Traitements screen show active treatments tab', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // Naviguer vers l'écran des traitements
    await tester.tap(find.text('Mes Traitements'));
    await tester.pumpAndSettle();

    // ✅ Vérifier que l'onglet "En cours" est affiché par défaut
    expect(find.text('En cours'), findsOneWidget);

    // ✅ Vérifier la présence des traitements actifs ou du message s'il n'y en a pas
    // Comme les données sont simulées, nous vérifions simplement que l'un des deux est présent
    bool hasTreatments =
        find.textContaining('Paracétamol').evaluate().isNotEmpty;
    bool hasEmptyMessage =
        find.text('Aucun traitement en cours').evaluate().isNotEmpty;

    expect(hasTreatments || hasEmptyMessage, true);
  });
}
