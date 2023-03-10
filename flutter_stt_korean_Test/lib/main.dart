import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp()
  )
  );
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final stt.SpeechToText speech = stt.SpeechToText();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('STT TEST입니다.', style: TextStyle(fontSize: 20)),
              GestureDetector(
                onTap: () async {
                  print('시작 클릭!');
                  _requestMicrophonePermission();

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromRGBO(125, 125, 125, 1)),
                  child: const Center(
                    child: Text(
                      "음성인식 시작",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  print('종료 클릭!');
                  endListening();

                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color.fromRGBO(125, 125, 125, 1)),
                  child: const Center(
                    child: Text(
                      "음성인식 종료",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      // 마이크 권한이 승인된 경우 처리할 로직을 작성합니다.
      print('마이크 허용');
      startListening();
    } else {
      // 마이크 권한이 거부된 경우 처리할 로직을 작성합니다.
      print('마이크 거절');
    }
  }

  Future<void> startListening() async {
    bool available = await speech.initialize(
      // debugLogging: true,
      onStatus: (status) {
        print('status: $status');
        if (status == 'listening') {
          // 음성 인식 시작
        }
        if (status == 'done') {
          // 음성 인식 종료
          // print('재시작!');
          // startListening();
        }
      },
      onError: (error) {
        print('error: $error');
        if (error.errorMsg == 'error_speech_timeout') {
          // startListening(); // 다시 시작
        }
      }
    );
    print('가능여부 $available');
    if ( available ) {
      speech.listen(
        onResult: (result) {
          print('result: ${result.recognizedWords}');
          // print(result);
        },
      );
    } else {
      print("음성인식을 사용할 수 없어요.");
    }
    // some time later...
    // speech.stop();
  }

  Future<void> endListening() async {
    speech.stop();
  }
}