import 'package:flutter/material.dart';
import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/riverpod/tasks/tasks_notifier.dart';
import 'package:flutter_app_todo/presentation/pages/tasks/tasks_router.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/app_scaffold_widget.dart';
import 'package:flutter_app_todo/widget/button/button_widget.dart';
import 'package:flutter_app_todo/presentation/common/show_modal/show_modal_new_task_widget.dart';
import 'package:flutter_app_todo/widget/card/card_task_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GroupTaskPage extends StatelessWidget {
  const GroupTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWidget(
      appBar: AppBar(
        backgroundColor: AppColors.colorSkyMist,
        title: const Text(
          'Todo list',
          style: TextStyle(color: AppColors.colorDeepBlue),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.calendar_month,
                    color: AppColors.colorSteelBlue,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.notifications_none,
                    color: AppColors.colorSteelBlue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 20),
          _HeaderSectionWidget(),
          SizedBox(height: 12),
          _CardTaskWidget(),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _HeaderSectionWidget extends StatelessWidget {
  const _HeaderSectionWidget();

  void _onPressed(BuildContext context, WidgetRef ref) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ShowModalNewTaskWidget(),
    );

    if (result == true) {
      await ref.read(tasksVmProvider.notifier).loadTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _TitleSectionWidget(),
        Consumer(
          builder: (context, ref, _) {
            return ButtonWidget(
              title: '+ New Task',
              textStyle: AppTextStyle.light14.copyWith(
                color: AppColors.colorPureWhite,
              ),
              onPressed: () => _onPressed(context, ref),
              backgroundColor: AppColors.colorOceanBlue,
              foregroundColor: AppColors.colorPureWhite,
            );
          },
        ),
      ],
    );
  }
}

class _TitleSectionWidget extends StatelessWidget {
  const _TitleSectionWidget();

  @override
  Widget build(BuildContext context) {
    final formatted = DateTime.now().formatFullDayMonth();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's Task", style: AppTextStyle.bold18),
        Text(formatted, style: AppTextStyle.light14),
      ],
    );
  }
}

class _CardTaskWidget extends ConsumerWidget {
  const _CardTaskWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskVm = ref.watch(tasksVmProvider);

    if (!taskVm.hasValue) {
      return const SizedBox.shrink();
    }

    final tasks = taskVm.requireValue;

    return ListView.separated(
      itemCount: tasks.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return CardTaskWidget(
          title: task.title,
          description: task.description,
          date: task.date,
          time: task.time,
          category: task.category,
          isCompleted: task.isCompleted,
          onTapCard: () {
            openEdit(context, task, index, ref);
          },
          onToggleComplete: () {
            ref.read(tasksVmProvider.notifier).toggleComplete(index);
          },
          onDelete: () =>
              ref.read(tasksVmProvider.notifier).deleteTask(task.id),
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
    );
  }

  void openEdit(
    BuildContext context,
    TaskDomain task,
    int index,
    WidgetRef ref,
  ) async {
    await context.push(
      GroupTaskRouter.detailsTask,
      extra: {'task': task, 'index': index},
    );
    ref.read(tasksVmProvider.notifier).loadTasks();
  }
}
