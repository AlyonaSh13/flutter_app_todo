import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';

class AppTextStyle {
  static const bold18 = TextStyle(
    color: AppColors.colorDeepBlue,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  static const medium16 = TextStyle(
    color: AppColors.colorDeepBlue,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const light14 = TextStyle(
    color: AppColors.colorSteelBlue,
    fontSize: 14,
    fontWeight: FontWeight.w300,
  );
  static const medium14 = TextStyle(
    color: AppColors.colorSkyMist,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const regular14 = TextStyle(
    color: AppColors.colorSoftRed,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
