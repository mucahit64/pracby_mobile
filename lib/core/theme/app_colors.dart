import 'package:flutter/material.dart';

abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF6D28D9);

  // Accent
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);

  // Semantic — same values as the web client's tailwind.config.js
  static const Color success = Color(0xFF58CC02); // web: positive
  static const Color error = Color(0xFFFF4B4B); // web: negative
  static const Color warning = Color(0xFFFF9600);
  static const Color info = Color(0xFF1CB0F6);

  // Feedback sheet backgrounds (web quiz page)
  static const Color successSurface = Color(0xFFE9F9EF);
  static const Color errorSurface = Color(0xFFFDECEC);
  static const Color acorn = Color(0xFFB45309); // web: text-amber-700

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0F0F1A);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Dark mode surfaces
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF25253D);
}
