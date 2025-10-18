import 'package:flutter_app_todo/domain/entities/task_domain.dart';
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
      path: detailsTask,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        final task = extra['task'] as TaskDomain;

        return ProviderScope(
          overrides: [detailsTaskPageDataProvider.overrideWithValue(task)],
          child: const DetailsTaskPage(),
        );
      },
    ),
  ];
}
