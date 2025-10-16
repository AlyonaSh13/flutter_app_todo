import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';

class IconButtonWidget extends StatelessWidget {
  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  final Widget icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.colorSkyMist),
        // shape: WidgetStateProperty.all(
        //   RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // ),
        shadowColor: WidgetStateProperty.all(
          AppColors.colorSteelBlue.withValues(alpha: 0.3),
        ),
        elevation: WidgetStateProperty.all(2),
      ),
      onPressed: onPressed,
    );
  }
}
