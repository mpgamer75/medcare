import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs principales - changement du vert au rouge
  static const Color primaryColor = Color(
    0xFFB23A48,
  ); // Rouge non vif principal
  static const Color secondaryColor = Color(
    0xFF3DA5D9,
  ); // Bleu médical secondaire (inchangé)
  static const Color accentColor = Color(0xFFD88C9A); // Rose clair d'accent

  // Couleurs de fond
  static const Color backgroundColor = Color(
    0xFFF5F7FA,
  ); // Fond gris très clair (inchangé)
  static const Color cardColor = Colors.white; // (inchangé)

  // Couleurs de texte (inchangées)
  static const Color textPrimary = Color(
    0xFF2D3748,
  ); // Gris foncé pour texte principal
  static const Color textSecondary = Color(
    0xFF718096,
  ); // Gris moyen pour texte secondaire
  static const Color textLight = Color(
    0xFFE2E8F0,
  ); // Gris clair pour texte sur fond foncé

  // Couleurs fonctionnelles (inchangées)
  static const Color success = Color(
    0xFF38B2AC,
  ); // Vert turquoise pour le succès
  static const Color error = Color(0xFFE53E3E); // Rouge pour les erreurs
  static const Color warning = Color(
    0xFFDD6B20,
  ); // Orange pour les avertissements
  static const Color info = Color(0xFF3182CE); // Bleu pour les informations

  // Gradients - modification pour utiliser des teintes de rouge
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFB23A48), Color(0xFFD88C9A)],
  );

  // Styles de texte (inchangés)
  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textPrimary,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  // Thème global de l'application
  static ThemeData get theme => ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: cardColor,
      background: backgroundColor,
      error: error,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryColor),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    iconTheme: const IconThemeData(color: primaryColor, size: 24),
    textTheme: const TextTheme(
      displayLarge: headingStyle,
      titleLarge: subheadingStyle,
      bodyLarge: bodyStyle,
      bodyMedium: captionStyle,
    ),
  );
}
