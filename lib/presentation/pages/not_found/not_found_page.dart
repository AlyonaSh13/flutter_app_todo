import 'package:flutter/material.dart';
import 'package:flutter_app_todo/widget/scaffold_widget.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScaffoldWidget(
      body: Center(child: CircularProgressIndicator(color: Colors.deepOrange)),
    );
  }
}
