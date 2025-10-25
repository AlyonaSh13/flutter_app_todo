import 'package:flutter/material.dart';
import 'package:flutter_app_todo/riverpod/details_task/details_task_notifier.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/scaffold_widget.dart';
import 'package:flutter_app_todo/widget/button/date_time_button_widget.dart';
import 'package:flutter_app_todo/widget/ink_well_material_widget.dart';

final detailsTaskPageDataProvider = Provider<String>(
  (ref) => throw Exception(),
);

class DetailsTaskPage extends ConsumerWidget {
  const DetailsTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskIdProvider = ref.read(detailsTaskPageDataProvider);
    final provider = detailsTaskVmProvider(
      DetailsTaskVmParams(id: taskIdProvider),
    );

    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        return Center(
          child: TextWidget('Error: $e', style: AppTextStyle.regular14),
        );
      },
      data: (data) => ScaffoldWidget(
        appBar: AppBar(
          title: const TextWidget('Task Details', style: AppTextStyle.bold18),
          centerTitle: true,
          backgroundColor: AppColors.colorSkyMist,
          iconTheme: const IconThemeData(color: AppColors.colorDeepBlue),
          actions: [
            IconButton(
              icon: Icon(
                data.isEditing ? Icons.save : Icons.edit,
                color: AppColors.colorDeepBlue,
              ),
              onPressed: () {
                data.isEditing ? notifier.saveChanges() : notifier.toggleEdit();
              },
            ),
          ],
        ),
        body: _BodyWidget(state: data, notifier: notifier),
      ),
    );
  }
}

class _BodyWidget extends ConsumerStatefulWidget {
  const _BodyWidget({required this.state, required this.notifier});

  final DetailsTaskState state;
  final DetailsTaskVm notifier;

  @override
  ConsumerState<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<_BodyWidget> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.state.task.title;
    _descriptionController.text = widget.state.task.description;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final notifier = widget.notifier;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.colorPureWhite,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CategoryColorBar(color: state.task.category.color),
              const SizedBox(height: 16),
              _EditableTextField(
                controller: _titleController,
                isEditing: state.isEditing,
                value: state.task.title,
                hint: 'Task name',
                style: AppTextStyle.bold18,
                onChanged: notifier.updateTitle,
              ),
              const SizedBox(height: 4),
              _EditableTextField(
                controller: _descriptionController,
                isEditing: state.isEditing,
                value: state.task.description,
                hint: 'Task description...',
                style: AppTextStyle.medium16.copyWith(
                  color: AppColors.colorSteelBlue,
                ),
                onChanged: notifier.updateDescription,
              ),
              const Divider(
                height: 30,
                thickness: 1.5,
                color: AppColors.colorSkyMist,
              ),
              Row(
                children: [
                  if (state.isEditing)
                    DateTimeButtonWidget(
                      title: 'Date',
                      value: state.task.date,
                      icon: Icons.calendar_month,
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2050),
                        );
                        if (picked != null) notifier.updateDate(picked);
                      },
                    )
                  else
                    _InfoRow(icon: Icons.calendar_month, text: state.task.date),
                  const SizedBox(width: 20),
                  if (state.isEditing)
                    DateTimeButtonWidget(
                      title: 'Time',
                      value: state.task.time,
                      icon: Icons.timer_outlined,
                      onTap: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          notifier.updateTime(picked, context);
                        }
                      },
                    )
                  else
                    _InfoRow(icon: Icons.timer_outlined, text: state.task.time),
                ],
              ),
              const SizedBox(height: 20),
              _CompletionToggle(
                isEditing: state.isEditing,
                isCompleted: state.task.isCompleted,
                onToggle: notifier.toggleComplete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Color strip at the top of the card
class _CategoryColorBar extends StatelessWidget {
  const _CategoryColorBar({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

/// Universal widget for editable or static text
class _EditableTextField extends StatelessWidget {
  const _EditableTextField({
    required this.controller,
    required this.isEditing,
    required this.value,
    required this.hint,
    required this.style,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool isEditing;
  final String value;
  final String hint;
  final TextStyle style;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return TextField(
        controller: controller,
        onChanged: onChanged,
        style: style,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      );
    } else {
      return TextWidget(
        value.isEmpty ? hint : value,
        style: style,
        isSelectable: true,
      );
    }
  }
}

/// Display of icon + text (date, time)
class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.colorOceanBlue, size: 20),
        const SizedBox(width: 8),
        TextWidget(text, style: AppTextStyle.light14),
      ],
    );
  }
}

/// “Completed” status switch widget
class _CompletionToggle extends StatelessWidget {
  const _CompletionToggle({
    required this.isEditing,
    required this.isCompleted,
    required this.onToggle,
  });

  final bool isEditing;
  final bool isCompleted;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWellMaterialWidget(
          borderRadius: BorderRadius.circular(100),
          onTap: isEditing ? onToggle : null,
          child: Icon(
            isCompleted
                ? Icons.check_circle_outline
                : Icons.radio_button_unchecked,
            color: AppColors.colorMintGreen,
            size: 22,
          ),
        ),
        const SizedBox(width: 8),
        TextWidget(
          isCompleted ? 'Task completed' : 'In progress',
          style: AppTextStyle.light14,
        ),
      ],
    );
  }
}
