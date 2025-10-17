import 'package:flutter/material.dart';
import 'package:flutter_app_todo/riverpod/creation_task/creation_task_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app_todo/core/utils/date_time_extension.dart';
import 'package:flutter_app_todo/core/utils/get_task_category_color.dart';
import 'package:flutter_app_todo/domain/task_domain.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/app_text_field_widget.dart';
import 'package:flutter_app_todo/widget/button/button_widget.dart';
import 'package:flutter_app_todo/widget/button/date_time_button_widget.dart';
import 'package:flutter_app_todo/widget/radio_widget.dart';

class ShowModalNewTaskWidget extends StatelessWidget {
  const ShowModalNewTaskWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        ref.listen(creationTaskVmProvider, (previous, next) {
          if (next.isSuccess) {
            context.pop(true);
          }
        });

        return const _ShowModalNewTaskWidget();
      },
    );
  }
}

class _ShowModalNewTaskWidget extends ConsumerStatefulWidget {
  const _ShowModalNewTaskWidget();

  @override
  ConsumerState<_ShowModalNewTaskWidget> createState() =>
      _ShowModalNewTaskWidgetState();
}

class _ShowModalNewTaskWidgetState
    extends ConsumerState<_ShowModalNewTaskWidget> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifierState = ref.watch(creationTaskVmProvider);
    final notifier = ref.read(creationTaskVmProvider.notifier);
    final height = MediaQuery.of(context).size.height * 0.85;

    return Container(
      padding: const EdgeInsets.all(20),
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.colorSnowWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                'New Task Todo',
                style: AppTextStyle.bold18,
                textAlign: TextAlign.center,
              ),
            ),
            const Divider(thickness: 1.2, color: AppColors.colorSkyMist),
            const SizedBox(height: 12),
            const Text('Title Task', style: AppTextStyle.normal16),
            const SizedBox(height: 6),
            AppTextFieldWidget(
              controller: _titleController,
              hintText: 'Add Task Name',
              maxLine: 1,
              onTextRecognized: (value) {
                _titleController.text = value;
              },
            ),
            const SizedBox(height: 12),
            const Text('Description', style: AppTextStyle.normal16),
            const SizedBox(height: 6),
            AppTextFieldWidget(
              controller: _descriptionController,
              hintText: 'Add Descriptions',
              maxLine: 5,
              onTextRecognized: (value) {
                _descriptionController.text = value;
              },
            ),
            const SizedBox(height: 12),
            const Text('Category', style: AppTextStyle.normal16),
            _RadioGroupWidget(
              selectedRadio: notifierState.task.category,
              onChanged: (taskCategory) {
                if (taskCategory == null) return;
                notifier.updateTask(
                  notifierState.task.copyWith(category: taskCategory),
                );
              },
            ),
            const SizedBox(height: 12),
            _RowDateTimeButtonsWidget(
              date: notifierState.task.date,
              time: notifierState.task.time,
              onChangedDate: (String value) {
                notifier.updateTask(notifierState.task.copyWith(date: value));
              },
              onChangedTime: (String value) {
                notifier.updateTask(notifierState.task.copyWith(time: value));
              },
            ),
            const SizedBox(height: 20),
            _RowButtonsWidget(
              titleController: _titleController,
              descriptionController: _descriptionController,
              selectedRadio: notifierState.task.category,
              date: notifierState.task.date,
              time: notifierState.task.time,
            ),
          ],
        ),
      ),
    );
  }
}

class _RadioGroupWidget extends StatelessWidget {
  const _RadioGroupWidget({
    required this.selectedRadio,
    required this.onChanged,
  });

  final TaskCategory selectedRadio;
  final void Function(TaskCategory? taskCategory) onChanged;

  @override
  Widget build(BuildContext context) {
    final values = TaskCategory.values
        .where((e) => e != TaskCategory.none)
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        const double spacing = 6;
        final double width = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          children: List.generate(values.length, (index) {
            final item = values[index];

            return SizedBox(
              width: width,
              child: RadioWidget(
                titleRadio: item.title,
                categoryColor: item.color,
                value: item,
                groupValue: selectedRadio,
                onChanged: onChanged,
              ),
            );
          }),
        );
      },
    );
  }
}

class _RowDateTimeButtonsWidget extends ConsumerWidget {
  const _RowDateTimeButtonsWidget({
    required this.date,
    required this.time,
    required this.onChangedDate,
    required this.onChangedTime,
  });

  final String date;
  final String time;
  final void Function(String value) onChangedDate;
  final void Function(String value) onChangedTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DateTimeButtonWidget(
          titleText: 'Date',
          valueText: date,
          iconSection: Icons.calendar_month,
          onTap: () async {
            final dateResult = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2025),
              lastDate: DateTime(2050),
            );

            if (dateResult != null) {
              onChangedDate(dateResult.formatDayMonthYear());
            }
          },
        ),
        const SizedBox(width: 22),
        DateTimeButtonWidget(
          titleText: 'Time',
          valueText: time,
          iconSection: Icons.timer_outlined,
          onTap: () async {
            final timeResult = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (timeResult != null) {
              onChangedTime(timeResult.format(context));
            }
          },
        ),
      ],
    );
  }
}

class _RowButtonsWidget extends ConsumerWidget {
  const _RowButtonsWidget({
    required this.titleController,
    required this.descriptionController,
    required this.selectedRadio,
    required this.date,
    required this.time,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TaskCategory selectedRadio;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            titleText: 'Cancel',
            textStyle: AppTextStyle.light14,
            onPressed: () => context.pop(),
            backgroundColor: AppColors.colorPureWhite,
            foregroundColor: AppColors.colorOceanBlue,
            side: const BorderSide(color: AppColors.colorOceanBlue),
          ),
        ),
        const SizedBox(width: 22),
        Expanded(
          child: ButtonWidget(
            titleText: 'Create',
            textStyle: AppTextStyle.light14.copyWith(
              color: AppColors.colorPureWhite,
            ),
            onPressed: () {
              if (titleController.text.isEmpty) return;
              ref
                  .read(creationTaskVmProvider.notifier)
                  .add(
                    TaskDomain(
                      title: titleController.text,
                      description: descriptionController.text,
                      date: date,
                      time: time,
                      category: selectedRadio,
                      isCompleted: false,
                    ),
                  );
            },
            backgroundColor: AppColors.colorOceanBlue,
            foregroundColor: AppColors.colorPureWhite,
          ),
        ),
      ],
    );
  }
}
