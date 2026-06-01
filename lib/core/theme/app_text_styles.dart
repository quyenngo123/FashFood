import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Toàn bộ text style dùng trong app FastFood
class AppTextStyles {
  AppTextStyles._();

  // === HEADING ===
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // === BODY ===
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  // === BUTTON ===
  static const TextStyle button = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.3,
  );

  // === PRICE ===
  static const TextStyle price = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.price,
  );

  static const TextStyle priceSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.price,
  );

  // === PROMO ===
  static const TextStyle promo = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.promo,
  );

  // === LABEL / CAPTION ===
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // === APP NAME (Splash / Header) ===
  static const TextStyle appName = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: AppColors.primaryDark,
    letterSpacing: 1.5,
  );

  static const TextStyle appNameOnPrimary = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: AppColors.textOnPrimary,
    letterSpacing: -0.5,
  );
}