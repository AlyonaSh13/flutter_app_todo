import 'package:flutter/material.dart';
import 'package:flutter_app_todo/domain/entities/task_domain.dart';
import 'package:flutter_app_todo/presentation/common/show_modal/show_modal_new_task_widget.dart';
import 'package:flutter_app_todo/presentation/pages/tasks/tasks_router.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/riverpod/calendar_tasks/calendar_tasks_notifier.dart';
import 'package:flutter_app_todo/riverpod/tasks/tasks_notifier.dart';
import 'package:flutter_app_todo/widget/calendar_widget.dart';
import 'package:flutter_app_todo/widget/card/card_task_widget.dart';
import 'package:flutter_app_todo/widget/scaffold_widget.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTaskPage extends ConsumerWidget {
  const CalendarTaskPage({super.key});

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
  Widget build(BuildContext context, WidgetRef ref) {
    const provider = calendarTasksVmProvider;

    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    ref.listen(tasksVmProvider, (prev, next) {
      notifier.refresh();
    });

    return ScaffoldWidget(
      appBar: AppBar(
        title: const TextWidget('Calendar', style: AppTextStyle.bold18),
        centerTitle: true,
        backgroundColor: AppColors.colorSkyMist,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onPressed(context, ref),
        backgroundColor: AppColors.colorOceanBlue,
        child: const Icon(Icons.add, color: AppColors.colorPureWhite),
      ),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: TextWidget('Error! $error', style: AppTextStyle.regular14),
        ),
        data: (data) => _CalendarTaskBody(state: data, notifier: notifier),
      ),
    );
  }
}

class _CalendarTaskBody extends ConsumerStatefulWidget {
  const _CalendarTaskBody({required this.state, required this.notifier});

  final CalendarTasksState state;
  final CalendarTasksVm notifier;

  @override
  ConsumerState<_CalendarTaskBody> createState() => _CalendarTaskBodyState();
}

class _CalendarTaskBodyState extends ConsumerState<_CalendarTaskBody> {
  CalendarFormat _format = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    final tasks = widget.state.tasks;

    return Padding(
      padding: const EdgeInsetsGeometry.only(left: 20, right: 20, bottom: 20),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: CalendarWidget(
              selectedDate: widget.state.selectedDate,
              countMap: widget.state.calendarMap,
              format: _format,
              onFormatChanged: (f) => setState(() => _format = f),
              onDaySelected: widget.notifier.selectDate,
            ),
          ),
          tasks.isEmpty
              ? const _EmptyTaskWidget()
              : _TaskListWidget(tasks: tasks),
        ],
      ),
    );
  }
}

class _EmptyTaskWidget extends StatelessWidget {
  const _EmptyTaskWidget();

  @override
  Widget build(BuildContext context) {
    return const SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: TextWidget(
            'No tasks for this date',
            style: AppTextStyle.light14,
          ),
        ),
      ),
    );
  }
}

class _TaskListWidget extends ConsumerWidget {
  const _TaskListWidget({required this.tasks});

  final List<TaskDomain> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverList.separated(
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
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
            await context.push<TaskDomain>(
              '${GroupTaskRouter.detailsTask}/${task.id}',
            );
          },
          onToggleComplete: () {
            ref.read(tasksVmProvider.notifier).toggleComplete(task.id);
          },
          onDelete: () {
            ref.read(tasksVmProvider.notifier).deleteById(task.id);
          },
        );
      },
    );
  }
}
