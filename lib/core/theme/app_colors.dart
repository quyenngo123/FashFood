import 'package:flutter/material.dart';

/// Toàn bộ màu sắc dùng trong app FastFood
class AppColors {
  AppColors._();

  // === PRIMARY — Xanh dương ===
  static const Color primary = Color(0xFF29B6F6);
  static const Color primaryLight = Color(0xFF81D4FA);
  static const Color primaryDark = Color(0xFF0D47A1);

  // === ACCENT — Cam (giá, khuyến mãi) ===
  static const Color price = Color(0xFFFF7043);
  static const Color promo = Color(0xFFFF9800);

  // === SEMANTIC ===
  static const Color success = Color(0xFF4CAF50); // Thành công
  static const Color error = Color(0xFFF44336);   // Lỗi
  static const Color warning = Color(0xFFFFB300);

  // === BACKGROUND ===
  static const Color background = Color(0xFFF5F5F5); // Nền app xám trắng
  static const Color cardBackground = Colors.white;   // Card món ăn

  // === TEXT ===
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF90A4AE);
  static const Color textOnPrimary = Colors.white;

  // === BORDER ===
  static const Color border = Color(0xFFB3E5FC);
  static const Color divider = Color(0xFFE3F2FD);

  // === INPUT ===
  static const Color inputBackground = Color(0xFFF0F9FF);
}