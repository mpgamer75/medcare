import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcare/main.dart';

void main() {
  testWidgets('Home screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Vérifie la présence du titre "MedCare"
    expect(find.text('MedCare'), findsOneWidget);

    // Vérifie la présence du texte de bienvenue
    expect(find.text('Bienvenue 👋'), findsOneWidget);

    // Vérifie la présence des boutons de traitement et de rendez-vous
    expect(find.text('Mes Traitements'), findsOneWidget);
    expect(find.text('Mes Rendez-vous'), findsOneWidget);

    // Vérifie la présence du bouton de profil
    expect(find.text('Mon Profil'), findsOneWidget);
  });
}
