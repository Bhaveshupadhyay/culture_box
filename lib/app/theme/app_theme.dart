import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

export 'app_spacing.dart';
export 'app_text_styles.dart';

class AppColors {
  static const Color background = Color(0xFF070709);
  static const Color surface = Color(0xFF141418);
  static const Color surfaceSecondary = Color(0xFF1C1C22);
  static const Color darkBanner = Color(0xFF121118);
  
  // Brand Logo & Accent Colors (Figma Match)
  static const Color logoRedOrange = Color(0xFFFF3B00);
  static const Color logoGold = Color(0xFFFFB800);
  static const Color primaryOrange = Color(0xFFFF4500);
  static const Color primaryGold = Color(0xFFFFB800);
  static const Color primaryBlue = Color(0xFFFF3B00);
  
  static const LinearGradient logoGradient = LinearGradient(
    colors: [Color(0xFFFF3B00), Color(0xFFFFB800)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFFFF3B00), Color(0xFFFF9900)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9EA0A6);
  static const Color textMuted = Color(0xFF6C6E76);
  static const Color cardBorder = Color(0xFF26262E);
  static const Color buttonDark = Color(0xFF202028);
  static const Color ratingBadgeBg = Color(0xFF1C1C22);
  static const Color badgeGreen = Color(0xFF00E676);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.background,
        primary: AppColors.logoRedOrange,
        secondary: AppColors.logoGold,
        onSurface: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      fontFamily: GoogleFonts.inter().fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceSecondary,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        actionTextColor: AppColors.logoGold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.background,
        width: 320,
      ),
    );
  }
}
