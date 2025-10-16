import 'package:flutter/material.dart';

class InkWellMaterialWidget extends StatelessWidget {
  const InkWellMaterialWidget({
    super.key,
    required this.child,
    this.color,
    this.borderRadius = BorderRadius.zero,
    this.onTap,
  });

  final Widget child;
  final Color? color;
  final BorderRadius borderRadius;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              highlightColor: color != null ? Colors.transparent : null,
              overlayColor: color != null ? WidgetStateProperty.all(color) : null,
              borderRadius: borderRadius,
              onTap: onTap ?? () {},
            ),
          ),
        ),
      ],
    );
  }
}
