import 'package:flutter/material.dart';
import 'package:flutter_app_todo/domain/task_with_index_domain.dart';
import 'package:flutter_app_todo/riverpod/details_task/details_task_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/app_scaffold_widget.dart';
import 'package:flutter_app_todo/widget/button/date_time_button_widget.dart';
import 'package:flutter_app_todo/widget/ink_well_material_widget.dart';

final detailsTaskPageDataProvider = Provider<TaskWithIndexDomain>(
  (ref) => throw Exception(),
);

class DetailsTaskPage extends ConsumerWidget {
  const DetailsTaskPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsTaskPageData = ref.watch(detailsTaskPageDataProvider);

    final params = DetailsTaskVmParams(
      task: detailsTaskPageData.task,
      index: detailsTaskPageData.index,
    );

    final provider = detailsTaskVmProvider(params);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return AppScaffoldWidget(
      appBar: AppBar(
        title: const Text('Task Details', style: AppTextStyle.bold18),
        centerTitle: true,
        backgroundColor: AppColors.colorSkyMist,
        iconTheme: const IconThemeData(color: AppColors.colorDeepBlue),
        actions: [
          IconButton(
            icon: Icon(
              state.isEditing ? Icons.save : Icons.edit,
              color: AppColors.colorDeepBlue,
            ),
            onPressed: () {
              state.isEditing ? notifier.saveChanges() : notifier.toggleEdit();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
          child: const Padding(
            padding: EdgeInsets.all(20),
            child: _BodyWidget(),
          ),
        ),
      ),
    );
  }
}

class _BodyWidget extends ConsumerStatefulWidget {
  const _BodyWidget();

  @override
  ConsumerState<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<_BodyWidget> {
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
    final detailsTaskPageData = ref.watch(detailsTaskPageDataProvider);

    final params = DetailsTaskVmParams(
      task: detailsTaskPageData.task,
      index: detailsTaskPageData.index,
    );

    final provider = detailsTaskVmProvider(params);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    return Column(
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
        const SizedBox(height: 8),
        _EditableTextField(
          controller: _descriptionController,
          isEditing: state.isEditing,
          value: state.task.description,
          hint: 'Task description...',
          style: AppTextStyle.normal16.copyWith(
            color: AppColors.colorSteelBlue,
          ),
          maxLines: 5,
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
                titleText: 'Date',
                valueText: state.task.date,
                iconSection: Icons.calendar_month,
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
                titleText: 'Time',
                valueText: state.task.time,
                iconSection: Icons.timer_outlined,
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
    this.maxLines = 1,
  });

  final TextEditingController? controller;
  final bool isEditing;
  final String value;
  final String hint;
  final TextStyle style;
  final int maxLines;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return TextField(
        // controller: TextEditingController(text: value)
        //   ..selection = TextSelection.collapsed(offset: value.length),
        controller: controller,
        onChanged: onChanged,
        style: style,
        maxLines: maxLines,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      );
    } else {
      return SelectableText(value.isEmpty ? hint : value, style: style);
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
        Text(text, style: AppTextStyle.light14),
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
        Text(
          isCompleted ? 'Task completed' : 'In progress',
          style: AppTextStyle.light14,
        ),
      ],
    );
  }
}

// class DetailsTaskPage extends ConsumerWidget {
//   const DetailsTaskPage({super.key, required this.taskWithIndex});

//   final TaskWithIndexDomain taskWithIndex;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final detailsState = ref.watch(detailsTaskProvider(taskWithIndex));
//     final notifier = ref.read(detailsTaskProvider(taskWithIndex).notifier);

//     return AppScaffoldWidget(
//       appBar: AppBar(
//         title: const Text('Details Task', style: AppTextStyle.bold18),
//         centerTitle: true,
//         backgroundColor: AppColors.colorSkyMist,
//         iconTheme: const IconThemeData(color: AppColors.colorDeepBlue),
//         actions: [
//           IconButton(
//             icon: Icon(
//               detailsState.isEditing ? Icons.save : Icons.edit,
//               color: AppColors.colorDeepBlue,
//             ),
//             onPressed: () {
//               if (detailsState.isEditing) {
//                 notifier.saveChanges();
//               } else {
//                 notifier.toggleEdit();
//               }
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: AppColors.colorPureWhite,
//               borderRadius: BorderRadius.circular(16),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.shade300,
//                   offset: const Offset(0, 2),
//                   blurRadius: 6,
//                 ),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     height: 8,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: detailsState.task.category.color,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   detailsState.isEditing
//                       ? TextField(
//                           onChanged: notifier.updateTitle,
//                           controller:
//                               TextEditingController(
//                                   text: detailsState.task.title,
//                                 )
//                                 ..selection = TextSelection.collapsed(
//                                   offset: detailsState.task.title.length,
//                                 ),
//                           style: AppTextStyle.bold18,
//                           decoration: const InputDecoration(
//                             border: InputBorder.none,
//                             hintText: 'Task name',
//                           ),
//                         )
//                       : Text(
//                           detailsState.task.title,
//                           style: AppTextStyle.bold18,
//                         ),

//                   const SizedBox(height: 8),

//                   detailsState.isEditing
//                       ? SizedBox(
//                           height: 100,
//                           child: SingleChildScrollView(
//                             child: TextField(
//                               onChanged: notifier.updateDescription,
//                               controller:
//                                   TextEditingController(
//                                       text: detailsState.task.description,
//                                     )
//                                     ..selection = TextSelection.collapsed(
//                                       offset:
//                                           detailsState.task.description.length,
//                                     ),
//                               style: AppTextStyle.normal16,
//                               maxLines: null,
//                               keyboardType: TextInputType.multiline,
//                               decoration: const InputDecoration(
//                                 border: InputBorder.none,
//                                 hintText: 'Task description...',
//                               ),
//                             ),
//                           ),
//                         )
//                       : SizedBox(
//                           height: 100,
//                           child: SingleChildScrollView(
//                             child: Text(
//                               detailsState.task.description,
//                               style: AppTextStyle.normal16.copyWith(
//                                 color: AppColors.colorSteelBlue,
//                               ),
//                             ),
//                           ),
//                         ),

//                   const Divider(
//                     height: 30,
//                     thickness: 1.5,
//                     color: AppColors.colorSkyMist,
//                   ),

//                   Row(
//                     children: [
//                       detailsState.isEditing
//                           ? DateTimeButtonWidget(
//                               titleText: 'Date',
//                               valueText: detailsState.task.date,
//                               iconSection: Icons.calendar_month,
//                               onTap: () async {
//                                 final getDate = await showDatePicker(
//                                   context: context,
//                                   initialDate: DateTime.now(),
//                                   firstDate: DateTime(2025),
//                                   lastDate: DateTime(2050),
//                                 );
//                                 if (getDate != null) {
//                                   notifier.updateDate(getDate);
//                                 }
//                               },
//                             )
//                           : Row(
//                               children: [
//                                 const Icon(
//                                   Icons.calendar_month,
//                                   color: AppColors.colorOceanBlue,
//                                   size: 20,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   detailsState.task.date,
//                                   style: AppTextStyle.light14,
//                                 ),
//                               ],
//                             ),
//                       const SizedBox(width: 20),
//                       detailsState.isEditing
//                           ? DateTimeButtonWidget(
//                               titleText: 'Time',
//                               valueText: detailsState.task.time,
//                               iconSection: Icons.timer_outlined,
//                               onTap: () async {
//                                 final getTime = await showTimePicker(
//                                   context: context,
//                                   initialTime: TimeOfDay.now(),
//                                 );
//                                 if (getTime != null) {
//                                   notifier.updateTime(getTime, context);
//                                 }
//                               },
//                             )
//                           : Row(
//                               children: [
//                                 const Icon(
//                                   Icons.timer_outlined,
//                                   color: AppColors.colorOceanBlue,
//                                   size: 20,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   detailsState.task.time,
//                                   style: AppTextStyle.light14,
//                                 ),
//                               ],
//                             ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   Row(
//                     children: [
//                       InkWellMaterialWidget(
//                         borderRadius: BorderRadius.circular(100),
//                         onTap: detailsState.isEditing
//                             ? notifier.toggleComplete
//                             : null,
//                         child: Icon(
//                           detailsState.task.isCompleted
//                               ? Icons.check_circle_outline
//                               : Icons.radio_button_unchecked,
//                           color: detailsState.isEditing
//                               ? AppColors.colorMintGreen
//                               : AppColors.colorMintGreen,
//                           size: 22,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         detailsState.task.isCompleted
//                             ? 'Task completed'
//                             : 'In progress',
//                         style: AppTextStyle.light14,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
