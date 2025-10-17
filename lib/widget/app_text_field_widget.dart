import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/speech_text_widget.dart';

class AppTextFieldWidget extends StatelessWidget {
  const AppTextFieldWidget({
    super.key,
    required this.hintText,
    required this.maxLine,
    required this.controller,
    required this.onTextRecognized,
  });

  final String hintText;
  final int maxLine;
  final TextEditingController controller;
  final void Function(String)? onTextRecognized;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.colorSkyMist,
            borderRadius: BorderRadius.circular(8),
          ),

          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: hintText,
              hintStyle: AppTextStyle.light14,
            ),
            maxLines: maxLine,
            textInputAction: TextInputAction.done,
          ),
        ),
        if (onTextRecognized != null)
          Positioned(
            bottom: 6,
            right: 10,
            child: SpeechTextWidget(onTextRecognized: onTextRecognized!),
          ),
      ],
    );
  }
}
