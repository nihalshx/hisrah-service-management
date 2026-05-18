import 'package:flutter/material.dart';

/// Central colour palette for the HISRAH Service Management module.
///
/// All widget colours must reference these constants — no hardcoded hex
/// values anywhere in the widget tree.
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0F5C68);
  static const Color primaryLight = Color(0xFF1A7D8C);
  static const Color primaryDark = Color(0xFF094550);
  static const Color onPrimary = Colors.white;

  // ── Action icons ───────────────────────────────────────────────────────────
  static const Color viewAction = Color(0xFF1E8449);
  static const Color editAction = Color(0xFFE07B39);
  static const Color deleteAction = Color(0xFFC0392B);

  // ── Data table ─────────────────────────────────────────────────────────────
  static const Color tableHeaderBg = Color(0xFF0F5C68);
  static const Color tableHeaderText = Colors.white;
  static const Color tableRowEven = Color(0xFFF5F9FA);
  static const Color tableRowOdd = Colors.white;
  static const Color tableBorder = Color(0xFFE0E0E0);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // ── Input ──────────────────────────────────────────────────────────────────
  static const Color inputBorder = Color(0xFFBDBDBD);
  static const Color inputFocusBorder = Color(0xFF0F5C68);

  // ── Backgrounds ────────────────────────────────────────────────────────────
  static const Color pageBackground = Color(0xFFF5F7F8);
  static const Color surface = Colors.white;

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFC0392B);
  static const Color success = Color(0xFF1E8449);
}
