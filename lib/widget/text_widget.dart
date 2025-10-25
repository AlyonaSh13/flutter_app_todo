import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.isSelectable = false,
  });

  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool isSelectable;

  @override
  Widget build(BuildContext context) {
    if (isSelectable) {
      return SelectableText(
        text,
        style: style,
        maxLines: maxLines,
        textAlign: textAlign,
      );
    } else {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }
  }
}
