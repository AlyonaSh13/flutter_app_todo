import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/ink_well_material_widget.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';

class DateTimeButtonWidget extends StatelessWidget {
  const DateTimeButtonWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(title, style: AppTextStyle.medium16),
          const SizedBox(height: 6),

          InkWellMaterialWidget(
            borderRadius: BorderRadius.circular(6),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.colorSkyMist,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(icon, color: AppColors.colorSteelBlue, size: 18),
                  const SizedBox(width: 6),
                  TextWidget(
                    value.isNotEmpty ? value : 'Not selected',
                    style: AppTextStyle.light14.copyWith(
                      color: AppColors.colorSteelBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
