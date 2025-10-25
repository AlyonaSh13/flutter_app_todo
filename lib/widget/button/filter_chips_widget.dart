import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';

class FilterChipsWidget extends StatelessWidget {
  const FilterChipsWidget({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.gradients,
  });

  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<Gradient>? gradients;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: List.generate(items.length, (index) {
        final isSelected = selectedIndex == index;
        final gradient = gradients != null && gradients!.length > index
            ? gradients![index]
            : const LinearGradient(
                colors: [AppColors.colorOceanBlue, AppColors.colorSkyMist],
              );

        return GestureDetector(
          onTap: () => onSelected(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected ? gradient : null,
              color: isSelected ? null : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.colorSteelBlue.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: TextWidget(
              items[index],
              style: isSelected
                  ? AppTextStyle.medium14
                  : AppTextStyle.medium14.copyWith(
                      color: AppColors.colorSteelBlue,
                    ),
            ),
          ),
        );
      }),
    );
  }
}
