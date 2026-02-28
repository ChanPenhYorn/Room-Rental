import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppTheme based on Figma Design Specifications
/// Primary Color: #55B97D (Vibrant Green)
/// Typography: Outfit (Google Fonts)
class AppTheme {
  // Figma Color Palette
  static const Color primaryGreen = Color(0xFF55B97D);
  static const Color secondaryGreen = Color(0xFFE8F5EE); // 10% opacity tint
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color secondaryGray = Color(0xFF757575);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color dividerGray = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFEF4444);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: surfaceWhite,
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        secondary: primaryBlack,
        surface: surfaceWhite,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: primaryBlack,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        const TextTheme(
          // Headline Large - 24px Bold (Screen Titles)
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primaryBlack,
          ),
          // Headline Small - 20px Bold (Card Titles)
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryBlack,
          ),
          // Body Medium - 16px Regular (Descriptions)
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: primaryBlack,
          ),
          // Label Small - 12px Medium (Captions, Distance tags)
          labelSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: secondaryGray,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: primaryBlack),
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryBlack,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Stadium shape
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dividerGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), // Pill shape
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
    );
  }
}
