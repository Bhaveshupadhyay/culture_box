import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

/// Centralized TextStyles for CultureBox TV Network application,
/// configured with Google Fonts Inter matching Figma specification.
class AppTextStyles {
  AppTextStyles._();

  // App Bar & Main Titles
  static TextStyle appBarTitle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
  );

  static TextStyle heroTitle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 26,
    fontWeight: FontWeight.w800,
    height: 1.1,
  );

  static TextStyle detailsTitle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.w800,
  );

  static TextStyle sectionTitle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  static TextStyle sectionHeader = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.2,
  );

  static TextStyle sectionHeaderSmall = GoogleFonts.inter(
    color: AppColors.textSecondary,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );

  // Cards & Badges
  static TextStyle cardTitle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  static TextStyle cardSubtitle = GoogleFonts.inter(
    color: Colors.white70,
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  static TextStyle cardRating = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w700,
  );

  static TextStyle badgeText = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );

  static TextStyle badgeMeta = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static TextStyle badgeRating = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  // Body & Descriptions
  static TextStyle bodyText = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 14,
    height: 1.5,
  );

  static TextStyle bodySecondary = GoogleFonts.inter(
    color: AppColors.textSecondary,
    fontSize: 13,
    height: 1.4,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    color: Colors.white70,
    fontSize: 12,
  );

  static TextStyle textMuted = GoogleFonts.inter(
    color: AppColors.textMuted,
    fontSize: 12,
  );

  // Search Screen
  static TextStyle searchHint = GoogleFonts.inter(
    color: AppColors.textMuted,
    fontSize: 14,
  );

  static TextStyle chipSelected = GoogleFonts.inter(
    color: Colors.black,
    fontWeight: FontWeight.w700,
    fontSize: 14,
  );

  static TextStyle chipUnselected = GoogleFonts.inter(
    color: Colors.white,
    fontWeight: FontWeight.w500,
    fontSize: 14,
  );

  static TextStyle emptyStateTitle = GoogleFonts.inter(
    color: Colors.white70,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static TextStyle emptyStateSubtitle = GoogleFonts.inter(
    color: AppColors.textMuted,
    fontSize: 12,
  );

  // Buttons & Actions
  static TextStyle buttonText = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.0,
  );

  static TextStyle buttonTextDark = GoogleFonts.inter(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
  );

  static TextStyle buttonTextPrimary = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
  );

  static TextStyle seeAll = GoogleFonts.inter(
    color: AppColors.logoGold,
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  // Choose Plan Screen
  static TextStyle planTitle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.0,
  );

  static TextStyle planPrice = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.w900,
  );

  static TextStyle planPeriod = GoogleFonts.inter(
    color: Colors.white70,
    fontSize: 14,
  );

  static TextStyle planResolution = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );

  static TextStyle featureText = GoogleFonts.inter(
    color: Colors.white70,
    fontSize: 13,
  );

  // Details Screen Rows
  static TextStyle detailLabel = GoogleFonts.inter(
    color: Colors.white70,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  static TextStyle detailValue = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 13,
  );

  static TextStyle detailValueAccent = GoogleFonts.inter(
    color: AppColors.logoGold,
    fontSize: 13,
    fontWeight: FontWeight.w700,
  );

  // Profile Screen
  static TextStyle profileName = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );

  static TextStyle profileSubscriber = GoogleFonts.inter(
    color: AppColors.logoGold,
    fontSize: 11,
    fontWeight: FontWeight.w800,
  );

  static TextStyle signOutText = GoogleFonts.inter(
    color: Colors.redAccent,
    fontWeight: FontWeight.w700,
  );

  // Drawer
  static TextStyle drawerTitle = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w900,
    letterSpacing: 1.1,
  );

  static TextStyle drawerDesc = GoogleFonts.inter(
    color: AppColors.textSecondary,
    fontSize: 12,
    height: 1.4,
  );

  static TextStyle drawerTile = GoogleFonts.inter(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static TextStyle drawerTileHighlight = GoogleFonts.inter(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.w800,
  );
}

/// Alias for AppTextStyles to support both naming styles
typedef TextStyles = AppTextStyles;
