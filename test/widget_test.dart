import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcare/main.dart';
import 'package:medcare/screens/profile.dart';
import 'package:medcare/screens/rdv.dart';
import 'package:medcare/screens/traitements.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    // 🏁 Lance l'application
    await tester.pumpWidget(const MyApp());

    // ✅ Vérifie la présence du titre "MedCare"
    expect(find.text('MedCare'), findsOneWidget);

    // ✅ Vérifie la présence du texte de bienvenue
    expect(find.text('Bienvenue 👋'), findsOneWidget);

    // ✅ Vérifie la présence des boutons de traitement et de rendez-vous
    expect(find.text('Mes Traitements'), findsOneWidget);
    expect(find.text('Mes Rendez-vous'), findsOneWidget);

    // ✅ Vérifie la présence du bouton de profil
    expect(find.text('Mon Profil'), findsOneWidget);
  });

  testWidgets('Navigation vers TraitementsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le bouton "Mes Traitements"
    await tester.tap(find.text('Mes Traitements'));
    await tester.pumpAndSettle();

    // ✅ Vérifie que TraitementsScreen est affiché après la navigation
    expect(find.byType(TraitementsScreen), findsOneWidget);
  });

  testWidgets('Navigation vers RendezvousScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le bouton "Mes Rendez-vous"
    await tester.tap(find.text('Mes Rendez-vous'));
    await tester.pumpAndSettle();

    // ✅ Vérifie que RendezvousScreen est affiché après la navigation
    expect(find.byType(RendezvousScreen), findsOneWidget);
  });

  testWidgets('Navigation vers ProfilScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // ✅ Appuie sur le bouton "Mon Profil"
    await tester.tap(find.text('Mon Profil'));
    await tester.pumpAndSettle();

    // ✅ Vérifie que ProfilScreen est affiché après la navigation
    expect(find.byType(ProfilScreen), findsOneWidget);
  });
}
