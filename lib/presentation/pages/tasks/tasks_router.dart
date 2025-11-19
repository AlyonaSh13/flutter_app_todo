import 'package:flutter_app_todo/presentation/pages/tasks/calendar_tasks_page.dart';
import 'package:flutter_app_todo/presentation/pages/tasks/details_task_page.dart';
import 'package:flutter_app_todo/presentation/pages/tasks/notification_settings_page.dart';
import 'package:flutter_app_todo/presentation/pages/tasks/tasks_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskRouter {
  static const String initial = '/';
  static const String detailsTask = '/details_task';
  static const String calendarTask = '/calendar_task';
  static const String notificationSettings = '/notification_settings';

  static List<RouteBase> get routes => [
    GoRoute(
      path: initial,
      builder: (context, state) {
        return const TasksPage();
      },
    ),
    GoRoute(
      path: '$detailsTask/:taskId',
      builder: (context, state) {
        final String taskId = state.pathParameters['taskId'] ?? '';

        return ProviderScope(
          overrides: [detailsTaskPageDataProvider.overrideWithValue(taskId)],
          child: const DetailsTaskPage(),
        );
      },
    ),
    GoRoute(
      path: calendarTask,
      builder: (context, state) {
        return const CalendarTaskPage();
      },
    ),
    GoRoute(
      path: notificationSettings,
      builder: (context, state) {
        return const NotificationSettingsPage();
      },
    ),
  ];
}
