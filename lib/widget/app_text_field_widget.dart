import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/speech_text_widget.dart';

class AppTextFieldWidget extends StatelessWidget {
  const AppTextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.onTextRecognized,
  });

  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onTextRecognized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.colorSkyMist,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 40, maxHeight: 160),
              child: Scrollbar(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: AppTextStyle.light14,
                    border: InputBorder.none,
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
          ),

          if (onTextRecognized != null) ...[
            const SizedBox(width: 8),
            SpeechTextWidget(onTextRecognized: onTextRecognized!),
          ],
        ],
      ),
    );
  }
}
