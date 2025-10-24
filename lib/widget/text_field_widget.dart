import 'package:flutter/material.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/resources/themes/app_text_style.dart';
import 'package:flutter_app_todo/widget/button/speech_text_widget.dart';
import 'package:flutter_app_todo/widget/text_widget.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.controller,
    required this.scrollController,
    required this.onTextRecognized,
    this.validator,
    this.focusNode,
    this.nextFocusNode,
    this.textInputAction = TextInputAction.next,
    this.maxLine = 1,
  });

  final String hintText;
  final TextEditingController controller;
  final ScrollController? scrollController;
  final void Function(String)? onTextRecognized;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final int? maxLine;

  @override
  Widget build(BuildContext context) {
    return FormField(
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<String> fieldState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.colorSkyMist,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: fieldState.hasError
                      ? AppColors.colorSoftRed
                      : Colors.transparent,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minHeight: 40,
                        maxHeight: 160,
                      ),
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                        scrollController: scrollController,
                        onChanged: fieldState.didChange,
                        onSubmitted: (_) {
                          if (nextFocusNode != null) {
                            FocusScope.of(context).requestFocus(nextFocusNode);
                          } else {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: hintText,
                          hintStyle: AppTextStyle.light14,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: maxLine,
                        textInputAction: textInputAction,
                      ),
                    ),
                  ),

                  if (onTextRecognized != null) ...[
                    const SizedBox(width: 8),
                    SpeechTextWidget(onTextRecognized: onTextRecognized!),
                  ],
                ],
              ),
            ),
            if (fieldState.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: TextWidget(
                  fieldState.errorText!,
                  style: AppTextStyle.regular14,
                ),
              ),
          ],
        );
      },
    );
  }
}
