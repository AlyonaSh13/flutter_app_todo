import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';
import 'package:go_router/go_router.dart';

class DialogHelper {
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String message,
  }) {
    return _showInfoDialog(
      context: context,
      message: message,
      icon: Icons.info,
      colorIcon: AppColors.colorOceanBlue,
    );
  }

  static Future<void> showErrorDialog(
    BuildContext context, {
    required String message,
  }) {
    return _showInfoDialog(
      context: context,
      message: message,
      icon: Icons.close,
      colorIcon: AppColors.colorSoftRed,
    );
  }

  static Future<void> _showInfoDialog({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color colorIcon,
  }) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.colorSnowWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          icon: Icon(icon, size: 28, color: colorIcon),
          content: TextWidget(
            message,
            style: AppTextStyle.light14.copyWith(
              color: AppColors.colorDeepBlue,
            ),
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => context.pop(context),
              child: TextWidget(
                'OK',
                style: AppTextStyle.medium14.copyWith(
                  color: AppColors.colorOceanBlue,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
