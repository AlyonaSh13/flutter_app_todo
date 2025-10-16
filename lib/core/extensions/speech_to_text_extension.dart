import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

extension SpeechToTextExtension on SpeechToText {
  Future<void> listenCustom({
    void Function(SpeechRecognitionResult result)? onResult,
  }) async {
    //TODO: get localeId
    await listen(
      onResult: onResult,
      // localeId: localeId,
    );
  }
}
