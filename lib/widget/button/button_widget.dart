import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.titleText,
    required this.textStyle,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    this.side,
  });

  final String titleText;
  final TextStyle textStyle;
  final void Function()? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final BorderSide? side;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: side,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      child: Text(titleText, style: textStyle),
    );
  }
}
