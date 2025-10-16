import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';

enum TaskCategory {
  learn,
  work,
  home,
  general,
  none;

  Color get color {
    return switch (this) {
      TaskCategory.learn => AppColors.colorSoftGreen,
      TaskCategory.work => AppColors.colorSoftOrange,
      TaskCategory.home => AppColors.colorSoftRed,
      TaskCategory.general => AppColors.colorDeepBlue,
      TaskCategory.none => AppColors.colorSkyMist,
    };
  }

  String get title {
    return switch (this) {
      TaskCategory.learn => 'Learn',
      TaskCategory.work => 'Work',
      TaskCategory.home => 'Home',
      TaskCategory.general => 'General',
      TaskCategory.none => '',
    };
  }
}
