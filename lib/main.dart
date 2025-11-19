import 'package:flutter/material.dart';
import 'package:flutter_app_todo/data/services/notification_service.dart';
import 'package:flutter_app_todo/presentation/navigation/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init(initScheduled: true);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: Routes.router, debugShowCheckedModeBanner: false);
  }
}
