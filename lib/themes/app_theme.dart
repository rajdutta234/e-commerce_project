import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2563EB), // Blue
    brightness: Brightness.light,
    surfaceTint: const Color(0xFFF5F6FA),
    background: const Color(0xFFF5F6FA),
    primary: const Color(0xFF2563EB), // Blue 600
    secondary: const Color(0xFF60A5FA), // Blue 400
    tertiary: const Color(0xFF38BDF8), // Blue 300
    error: const Color(0xFFEF4444),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: colorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: colorScheme.surfaceTint,
      elevation: 2,
      iconTheme: IconThemeData(color: colorScheme.primary),
      titleTextStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 22,
        color: colorScheme.primary,
      ),
    ),
    cardTheme: CardThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      shadowColor: Colors.black12,
      color: colorScheme.surface,
      margin: const EdgeInsets.all(8),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: colorScheme.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.primary.withOpacity(0.1),
      elevation: 2,
      labelTextStyle: MaterialStateProperty.all(
        GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      iconTheme: MaterialStateProperty.all(
        IconThemeData(color: colorScheme.primary),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      bodyLarge: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
      bodyMedium: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
      titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 22),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
} 