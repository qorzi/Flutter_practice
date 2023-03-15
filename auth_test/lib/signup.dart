import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:auth_test/api_service.dart';
import 'package:flutter/services.dart'; // 정규식 메서드 가져오기
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_test/home.dart';
import 'package:auth_test/custom_text_field.dart';
import 'dart:convert';

class SignUp extends StatefulWidget {
  final String email; // 이메일 필드 추가
  final String token; // 토큰 필드 추가

  const SignUp({required this.email, required this.token, super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? _nickname;
  String? _errorMessage;
  bool _isError = false;
  final _focusNode = FocusNode(); // 포커싱 여부를 추적하는 클래스 인스턴스
  
  // 위젯이 소멸될 때 호출되는 메서드
  @override
  void dispose() {
    _focusNode.dispose(); // 현재 위젯에서 포커스 해제
    super.dispose();
  }

  // 키보드 외 화면을 눌렀을 때, 포커스 해제 
  void _dismissKeyboard(BuildContext context) {
    final currentFocus = FocusScope.of(context); // 현재 포커싱된 위젯을 반환
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) { // 현재 포커싱된 위젯이 최상위 FocusScope가 아니면서, 포커싱이 존재한다면.
      currentFocus.focusedChild?.unfocus(); // 현재 포커싱된 자식 위젯의 포커싱을 해제
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _dismissKeyboard(context);
        },
        child: Container(
          color: Color(0xFFF2E4D9),
          child: Stack(
            children: [
              Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('사용하실 닉네임을 입력해주세요.'),
                      SizedBox(height: 16), // 공백
                      Stack( // 텍스트 필드와 에러 텍스트 위치를 위한 스택
                        children: [
                          CustomTextField(
                            onChanged: onNicknameChanged,
                            isError: _isError,
                          ),
                          Positioned(
                            bottom: 0,
                            child: ErrorMessage(errorMessage: _errorMessage)
                          ),
                        ]
                      ),
                      SizedBox(height: 16), // 공백
                      ElevatedButton(
                        onPressed: () {
                          _signUp(context);
                        },
                        child: Text('완료'),
                      ),
                    ]
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                right: 30,
                child: Image.asset(
                  'assets/main_logo_red_x1.png',
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 커스텀 텍스트 필드에 내려주기 위한 onChange-setState 함수
  void onNicknameChanged(String value) {
    setState(() {
      _nickname = value;
      _isError = false;
      _errorMessage = null;
    });
  }
  
  // 회원가입 로직
  Future<void> _signUp(BuildContext context) async {

    // 유효성 검증
    if (_nickname == null || _nickname == '') {
      setState(() {
        _errorMessage = '닉네임을 입력해주세요.';
        _isError = true;
      });
      return;
    }

    // API 요청
    ApiService _apiService = ApiService();
    Map<String, dynamic> userData = {
      'email': widget.email,
      'nickname': _nickname,
      'access_token': widget.token
    };
    print('body: $userData'); // 데이터 확인
    Response? response = await _apiService.signupUser(userData);
    print('응답: $response');

    // 디코딩
    Map<String, dynamic> decodeRes = jsonDecode(response.toString());

    // 상태 분기
    if (decodeRes['status'] == 409) {
      // 중복 닉네임 에러 409
      print('이미 존재하는 이메일 or 이미 존재하는 닉네임인 경우');

      setState(() {
        _errorMessage = decodeRes['message'];
        _isError = true;
      });

      return;
    } else if (decodeRes['status'] == 200) {
      // shared preferences에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', response.toString());
      print('저장 완료');

      setState(() {
        _errorMessage = null;
        _isError = false;
      });

      print('홈으로 이동!');
      Route home = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, home);

      return;
    } else {
      // 기타 에러
      print('기타 에러 발생');

      setState(() {
        _errorMessage = '요청이 잘못되었습니다.';
        _isError = true;
      });

      return;
    }
  }
}
                        
class ErrorMessage extends StatelessWidget {
  final String? errorMessage;
  const ErrorMessage({super.key, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        alignment: Alignment.centerLeft, // 왼쪽 정렬 추가
        child: Text(
          errorMessage ?? '',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.red
          ),
        ),
      ),
    );
  }
}