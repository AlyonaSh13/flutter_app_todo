import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_todo/core/extensions/speech_to_text_extension.dart';
import 'package:flutter_app_todo/resources/themes/app_colors.dart';
import 'package:flutter_app_todo/widget/button/icon_button_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechTextWidget extends StatefulWidget {
  const SpeechTextWidget({super.key, required this.onTextRecognized});

  final void Function(String text) onTextRecognized;

  @override
  State<SpeechTextWidget> createState() => _SpeechTextWidgetState();
}

class _SpeechTextWidgetState extends State<SpeechTextWidget> {
  final _speechToText = SpeechToText();
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initSpeechToText();
  }

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  Future<void> _initSpeechToText() async {
    await _speechToText.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    await _speechToText.listenCustom(onResult: _onSpeechResult);
    _isListening = true;
    setState(() {});
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
    _isListening = false;
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    if (_isListening) {
      final recognizedText = result.recognizedWords;
      widget.onTextRecognized(recognizedText);
    }
  }

  void _microphonePressed() async {
    final isNotListening =
        (await _speechToText.hasPermission) && _speechToText.isNotListening;

    if (isNotListening) {
      await _startListening();
    } else if (_speechToText.isListening) {
      await stopListening();
    } else {
      await _initSpeechToText();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isListened = _speechToText.isListening || _isListening;

    return SizedBox(
      height: 40,
      width: 40,
      child: AvatarGlow(
        animate: isListened,
        glowColor: AppColors.colorOceanBlue,
        duration: const Duration(milliseconds: 1000),
        child: IconButtonWidget(
          icon: Icon(
            isListened ? Icons.mic : Icons.mic_off,
            color: AppColors.colorSteelBlue,
            size: 24,
          ),
          onPressed: () => _microphonePressed(),
        ),
      ),
    );
  }
}
