import 'package:flutter_app_todo/presentation/pages/tasks/details_task_page.dart';
import 'package:flutter_app_todo/presentation/pages/tasks/group_task_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GroupTaskRouter {
  static const String initial = '/';
  static const String detailsTask = '/details_task';

  static List<RouteBase> get routes => [
    GoRoute(
      path: initial,
      builder: (context, state) {
        return const GroupTaskPage();
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
  ];
}
