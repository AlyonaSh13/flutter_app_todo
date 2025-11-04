import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_app_todo/core/extensions/date_time_extension.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/presentation/common/show_modal/show_modal_new_task_widget.dart';
import 'package:flutter_app_todo/presentation/pages/tasks/tasks_router.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/riverpod/tasks/tasks_notifier.dart';
import 'package:flutter_app_todo/widget/button/button_widget.dart';
import 'package:flutter_app_todo/widget/button/filter_chips_widget.dart';
import 'package:flutter_app_todo/widget/card/card_task_widget.dart';
import 'package:flutter_app_todo/widget/scaffold_widget.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldWidget(
      appBar: AppBar(
        backgroundColor: AppColors.colorSkyMist,
        title: const TextWidget(
          'Todo list',
          style: TextStyle(color: AppColors.colorDeepBlue),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    return IconButton(
                      onPressed: () async {
                        await context.push(GroupTaskRouter.calendarTask);
                        await ref.read(tasksVmProvider.notifier).refresh();
                      },
                      icon: const Icon(
                        Icons.calendar_month,
                        color: AppColors.colorSteelBlue,
                      ),
                    );
                  },
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
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          _HeaderSectionWidget(),
          SizedBox(height: 12),
          _TaskFilterNavigation(),
          SizedBox(height: 12),
          Expanded(child: _CardTaskWidget()),
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
      await ref.read(tasksVmProvider.notifier).refresh();
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
              textStyle: AppTextStyle.regular14.copyWith(
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
        const TextWidget("Today's Task", style: AppTextStyle.bold18),
        TextWidget(formatted, style: AppTextStyle.light14),
      ],
    );
  }
}

class _TaskFilterNavigation extends ConsumerWidget {
  const _TaskFilterNavigation();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksVmProvider);

    return state.when(
      data: (data) => FilterChipsWidget(
        items: const ['All', 'In progress', 'Completed'],
        gradients: const [
          LinearGradient(
            colors: [AppColors.colorOceanBlue, AppColors.colorSkyMist],
          ),
          LinearGradient(
            colors: [AppColors.colorSoftOrange, AppColors.colorSoftRed],
          ),
          LinearGradient(
            colors: [AppColors.colorSoftGreen, AppColors.colorMintGreen],
          ),
        ],
        selectedIndex: data.selectedIndex,
        onSelected: (index) {
          ref.read(tasksVmProvider.notifier).selectFilter(index);
        },
      ),
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _CardTaskWidget extends ConsumerWidget {
  const _CardTaskWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskVm = ref.watch(tasksVmProvider);

    return taskVm.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) {
        return Center(
          child: TextWidget('Error! $e', style: AppTextStyle.regular14),
        );
      },
      data: (data) {
        List<TaskDomain> tasks = data.tasks;

        if (data.selectedIndex == 1) {
          tasks = tasks.where((task) => !task.isCompleted).toList();
        } else if (data.selectedIndex == 2) {
          tasks = tasks.where((task) => task.isCompleted).toList();
        }

        if (tasks.isEmpty) {
          return const Center(
            child: TextWidget(
              'No tasks for the selected filter',
              style: AppTextStyle.light14,
            ),
          );
        }

        return ListView.separated(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return CardTaskWidget(
              title: task.title,
              description: task.description,
              date: task.date,
              time: task.time,
              category: task.category,
              isCompleted: task.isCompleted,
              onTapCard: () async {
                await context.push('${GroupTaskRouter.detailsTask}/${task.id}');
                await ref.read(tasksVmProvider.notifier).refresh();
              },
              onToggleComplete: () async {
                await ref
                    .read(tasksVmProvider.notifier)
                    .toggleComplete(task.id);
              },
              onDelete: () async {
                await ref.read(tasksVmProvider.notifier).deleteById(task.id);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 12);
          },
        );
      },
    );
  }
}
