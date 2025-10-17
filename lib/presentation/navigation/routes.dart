import 'package:flutter_app_todo/presentation/pages/tasks/tasks_router.dart';
import 'package:flutter_app_todo/presentation/pages/not_found/not_found_page.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static final GoRouter router = GoRouter(
    initialLocation: GroupTaskRouter.initial,
    routes: [...GroupTaskRouter.routes],
    errorBuilder: (context, state) => const NotFoundPage(),
  );
}
