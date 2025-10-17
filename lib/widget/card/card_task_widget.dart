import 'package:flutter/material.dart';
import 'package:flutter_app_todo/core/utils/get_task_category_color.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';

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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: AppTextStyle.bold18,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: AppTextStyle.normal16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Divider(
                            thickness: 1.5,
                            color: AppColors.colorSkyMist,
                          ),
                          Row(
                            children: [
                              Text(date, style: AppTextStyle.light14),
                              const SizedBox(width: 12),
                              Text(time, style: AppTextStyle.light14),
                            ],
                          ),
                          const SizedBox(height: 6),
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
