import 'package:flutter/material.dart';
import 'package:flutter_app_todo/domain/entities/enums/task_category.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';

class CardTaskWidget extends StatelessWidget {
  const CardTaskWidget({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    required this.onDelete,
    required this.isCompleted,
    required this.onToggleComplete,
    required this.onTapCard,
  });

  final String title;
  final String description;
  final String date;
  final String time;
  final TaskCategory category;
  final void Function()? onDelete;
  final bool isCompleted;
  final VoidCallback onToggleComplete;
  final void Function()? onTapCard;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.colorPureWhite,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.colorMintGreen.withValues(alpha: 0.2),
        highlightColor: AppColors.colorMintGreen.withValues(alpha: 0.1),
        onTap: onTapCard,
        child: Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.colorPureWhite,
            boxShadow: [
              BoxShadow(
                color: AppColors.colorOceanBlue.withValues(alpha: 0.15),
                blurRadius: 12,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppColors.colorSkyMist.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    decoration: BoxDecoration(
                      color: category.color,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 40,
                        top: 12,
                        bottom: 14,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            title,
                            style: AppTextStyle.bold18,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          TextWidget(
                            description,
                            style: AppTextStyle.medium16.copyWith(
                              color: AppColors.colorSteelBlue,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Divider(
                            thickness: 1.5,
                            color: AppColors.colorSkyMist,
                          ),
                          Row(
                            children: [
                              TextWidget(date, style: AppTextStyle.light14),
                              const SizedBox(width: 12),
                              TextWidget(time, style: AppTextStyle.light14),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: Icon(
                    isCompleted
                        ? Icons.check_circle_outline
                        : Icons.radio_button_unchecked,
                  ),
                  color: AppColors.colorMintGreen,
                  onPressed: onToggleComplete,
                ),
              ),

              Positioned(
                bottom: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.colorSoftRed,
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
