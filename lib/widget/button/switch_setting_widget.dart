import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';

class SwitchSettingWidget extends StatelessWidget {
  const SwitchSettingWidget({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(value: value, activeThumbColor: AppColors.colorOceanBlue, onChanged: onChanged);
  }
}
