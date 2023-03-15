import 'package:flutter/material.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:speech_to_text/speech_to_text.dart';


void main() {
  runApp(
    MaterialApp(
      home: WakeUp()
    )
  );
}

class WakeUp extends StatefulWidget {


  const WakeUp({Key? key}) : super(key: key);

  @override
  State<WakeUp> createState() => _WakeUpState();
}

class _WakeUpState extends State<WakeUp> {
  late PorcupineManager _porcupineManager;
  SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    print('wakeword 시작!');
    _initPorcupine();
  }

  void _initPorcupine() async {
    const accessKey = "d1erk8NonEE9s81e8mxaIrn69SBI01A2fxZzXgXfnfRTvMP0zqhwTA==";  // Picovoice Console(https://picovoice.ai/console/)에서 얻은 AccessKey
    String keywordAsset = "assets/hey_cocook.ppn";
    String modelAsset = "assets/porcupine_params_ko.pv";

    try {
      _porcupineManager = await PorcupineManager.fromKeywordPaths(
          accessKey,
          [keywordAsset],
          // Platform.isIOS
          // ? [Uri.parse('path_to_ios_keyword_file')]
          // : [Uri.parse('path_to_android_keyword_file')]
          _wakeWordCallback,
          modelPath: modelAsset);
      await _porcupineManager.start();  // PorcupineManager 시작
    } on PorcupineException catch (err) {
      // Porcupine 초기화 오류 처리
    }
  }

  void _wakeWordCallback(int keywordIndex) {
    if (keywordIndex == null) {
      // 예외 처리 및 로깅을 여기에 추가하십시오.
      print('Error: Keyword index is null.');
      return;
    }

    if (keywordIndex == 0) {
      // "hey, cocook"이 감지됨
      print('hey, cocook 인식완료!');
      _listen();
    }
  }

  @override
  void dispose() {
    _porcupineManager?.stop();  // PorcupineManager 중지
    _porcupineManager?.delete();  // PorcupineManager 삭제
    print('wakeword 제거!');
    super.dispose();
  }

  void _listen() async {
    print('음성인식 시작!');
    bool available = await _speechToText.initialize(
      onStatus: (status) => setState(() => _isListening = status == 'listening'),
      onError: (error) => print(error),
    );
    if (available) {
      _speechToText.listen(
        onResult: (result) => setState(() => _text = result.recognizedWords),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('wakeUp!')),
      body: Column(
        children: [
          Text(_isListening ? 'Stop Listening' : 'Start Listening'),
          Text(_text)
        ],
      ),
    );
  }
}

