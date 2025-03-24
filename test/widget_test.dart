import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcare/main.dart';
import 'package:medcare/screens/profile.dart';
import 'package:medcare/screens/traitements.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    // 🏁 Lance l'application
    await tester.pumpWidget(const MyApp());

    // ✅ Vérifie la présence du titre "MedCare"
    expect(find.text('MedCare'), findsOneWidget);

    // ✅ Vérifie la présence du texte de bienvenue
    expect(find.text('Bienvenue 👋'), findsOneWidget);

    // ✅ Vérifie la présence du bouton de traitement
    expect(find.text('Mes Traitements'), findsOneWidget);

    // ✅ Vérifie la présence du bouton de profil
    expect(find.text('Mon Profil'), findsOneWidget);

    // Vérifie que le bouton de rendez-vous n'existe plus
    expect(find.text('Mes Rendez-vous'), findsNothing);
  });

  testWidgets('Navigation vers TraitementsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le bouton "Mes Traitements"
    await tester.tap(find.text('Mes Traitements'));
    await tester.pumpAndSettle();

    // ✅ Vérifie que TraitementsScreen est affiché après la navigation
    expect(find.byType(TraitementsScreen), findsOneWidget);
  });

  testWidgets('Navigation vers ProfilScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le bouton "Mon Profil"
    await tester.tap(find.text('Mon Profil'));
    await tester.pumpAndSettle();

    // ✅ Vérifie que ProfilScreen est affiché après la navigation
    expect(find.byType(ProfilScreen), findsOneWidget);
  });

  testWidgets('BottomNavigationBar contient 3 éléments', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Vérifie que la BottomNavigationBar contient désormais 3 éléments
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
}
