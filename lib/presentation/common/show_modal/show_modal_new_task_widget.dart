import 'package:flutter/material.dart';
import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/core/utils/constants.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/presentation/common/dialogs/dialog_helper.dart';
import 'package:flutter_app_todo/riverpod/creation_task/creation_task_notifier.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_app_todo/domain/entities/enums/task_category.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/text_field_widget.dart';
import 'package:flutter_app_todo/widget/button/button_widget.dart';
import 'package:flutter_app_todo/widget/button/date_time_button_widget.dart';
import 'package:flutter_app_todo/widget/button/radio_widget.dart';
import 'package:intl/intl.dart';

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
  final _titleScrollController = ScrollController();
  final _descriptionController = TextEditingController();
  final _descriptionScrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleScrollController.dispose();
    _titleFocusNode.dispose();
    _descriptionController.dispose();
    _descriptionScrollController.dispose();
    _descriptionFocusNode.dispose();
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: TextWidget(
                  'New Task Todo',
                  style: AppTextStyle.bold18,
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(thickness: 1.2, color: AppColors.colorSkyMist),
              const SizedBox(height: 12),
              const TextWidget('Title Task *', style: AppTextStyle.medium16),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: _titleController,
                scrollController: _titleScrollController,
                hintText: 'Add Task Name',
                onTextRecognized: (value) {
                  _titleController.text = value;
                },
                focusNode: _titleFocusNode,
                nextFocusNode: _descriptionFocusNode,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'The name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              const TextWidget('Description', style: AppTextStyle.medium16),
              const SizedBox(height: 6),
              TextFieldWidget(
                controller: _descriptionController,
                scrollController: _descriptionScrollController,
                hintText: 'Add Descriptions',
                focusNode: _descriptionFocusNode,
                onTextRecognized: (value) {
                  _descriptionController.text = value;
                },
                textInputAction: TextInputAction.newline,
                maxLine: null,
              ),
              const SizedBox(height: 12),
              const TextWidget('Category', style: AppTextStyle.medium16),
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
                onChangedDate: (value) => notifier.updateDate(value),
                onChangedTime: (value) => notifier.updateTime(value),
              ),
              const SizedBox(height: 20),
              _RowButtonsWidget(
                formKey: _formKey,
                titleFocusNode: _titleFocusNode,
                titleController: _titleController,
                descriptionController: _descriptionController,
                selectedRadio: notifierState.task.category,
                date: notifierState.task.date,
                time: notifierState.task.time,
              ),
            ],
          ),
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

  Future<void> _pickDate(BuildContext context) async {
    final dateResult = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (dateResult != null) {
      onChangedDate(dateResult.formatDayMonthYear());
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    if (date.isEmpty) {
      await DialogHelper.showInfoDialog(
        context,
        message: 'Please select a date first',
      );
      return;
    }

    final now = DateTime.now();
    final selectedDate =
        DateFormat(DateFormats.dayMonthYear).tryParse(date) ?? now;

    final timeResult = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timeResult != null) {
      final isSameDay =
          selectedDate.year == now.year &&
          selectedDate.month == now.month &&
          selectedDate.day == now.day;

      final selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        timeResult.hour,
        timeResult.minute,
      );

      if (isSameDay && selectedDateTime.isBefore(now)) {
        await DialogHelper.showInfoDialog(
          context,
          message: 'Select a future time',
        );
        return;
      }

      onChangedTime(timeResult.format(context));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DateTimeButtonWidget(
          title: 'Date',
          value: date,
          icon: Icons.calendar_month,
          onTap: () => _pickDate(context),
        ),
        const SizedBox(width: 22),
        DateTimeButtonWidget(
          title: 'Time',
          value: time,
          icon: Icons.timer_outlined,
          onTap: () => _pickTime(context),
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
    required this.formKey,
    required this.titleFocusNode,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TaskCategory selectedRadio;
  final String date;
  final String time;
  final GlobalKey<FormState> formKey;
  final FocusNode titleFocusNode;

  Future<void> _validateAndCreateTask(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (!_isFormValid(formKey, titleFocusNode)) return;

    final now = DateTime.now();
    if (!await _isDateTimeValid(context, date, time, now)) return;

    FocusScope.of(context).unfocus();

    final newTask = TaskDomain.empty(
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      date: date,
      time: time,
      category: selectedRadio,
    );

    await ref.read(creationTaskVmProvider.notifier).addTask(newTask);
  }

  bool _isFormValid(GlobalKey<FormState> formKey, FocusNode focusNode) {
    final formState = formKey.currentState;
    final isValid = formState?.validate() ?? false;
    if (!isValid) focusNode.requestFocus();
    return isValid;
  }

  Future<bool> _isDateTimeValid(
    BuildContext context,
    String date,
    String time,
    DateTime now,
  ) async {
    if (date.isEmpty || time.isEmpty) return true;

    final selectedDate = DateFormat(DateFormats.dayMonthYear).tryParse(date);
    if (selectedDate == null) return true;

    try {
      final selectedDateTime = _combineDateTime(selectedDate, time);

      final sameMinute =
          selectedDateTime.year == now.year &&
          selectedDateTime.month == now.month &&
          selectedDateTime.day == now.day &&
          selectedDateTime.hour == now.hour &&
          selectedDateTime.minute == now.minute;

      if (sameMinute) {
        await DialogHelper.showInfoDialog(
          context,
          message: 'Selected time cannot be the same as the current time',
        );
        return false;
      }
    } catch (_) {
      await DialogHelper.showInfoDialog(
        context,
        message: 'Invalid time format',
      );
      return false;
    }
    return true;
  }

  DateTime _combineDateTime(DateTime date, String timeStr) {
    final timeLower = timeStr.toLowerCase().trim();
    final isPM = timeLower.contains('pm');
    final clean = timeLower.replaceAll(RegExp('[^0-9:]'), '');
    final parts = clean.split(':');

    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;

    if (isPM && hour < 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            title: 'Cancel',
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
            title: 'Create',
            textStyle: AppTextStyle.light14.copyWith(
              color: AppColors.colorPureWhite,
            ),
            onPressed: () => _validateAndCreateTask(context, ref),
            backgroundColor: AppColors.colorOceanBlue,
            foregroundColor: AppColors.colorPureWhite,
          ),
        ),
      ],
    );
  }
}
