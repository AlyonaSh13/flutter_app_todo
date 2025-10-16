import 'package:flutter/material.dart';
import 'package:flutter_app_todo/core/utils/get_task_category_color.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget({
    super.key,
    required this.titleRadio,
    required this.categoryColor,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  final String titleRadio;
  final Color categoryColor;
  final TaskCategory value;
  final TaskCategory groupValue;
  final ValueChanged<TaskCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: categoryColor),
      child: RadioGroup(
        groupValue: groupValue,
        onChanged: onChanged,
        child: RadioListTile<TaskCategory>(
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
          title: Transform.translate(
            offset: const Offset(-12, 0),
            child: Text(
              titleRadio,
              style: AppTextStyle.light14.copyWith(color: categoryColor),
            ),
          ),
          value: value,
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? categoryColor
                : categoryColor,
          ),
        ),
      ),
    );
  }
}
