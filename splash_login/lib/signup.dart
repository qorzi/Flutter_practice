import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:splash_login/api_service.dart';
import 'package:flutter/services.dart'; // 정규식 메서드 가져오기
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        color: Color(0xFFF2E4D9),
        child: Stack(
          children: [
            Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('사용하실 닉네임을 입력해주세요.'),
                    TextField(
                      autofocus: true, // 자동 포커싱
                      inputFormatters: [
                        // 정규화 필터링 포메터
                        FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|ㅏ-ㅣ|가-힣a-zA-Z]')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          // 값이 변할때 마다 _nickname 변경
                          _nickname = value;
                        });
                      },
                    ),
                    SizedBox(height: 16), // 공백
                    Text(_errorMessage ?? ''), // null이 아닐 경우만, 표시.
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
    );
  }
  
  Future<void> _signUp(BuildContext context) async {

    // 유효성 검증
    if (_nickname == null) {
      setState(() {
        _errorMessage = '닉네임을 입력해주세요.';
      });
      return;
    }

    ApiService _apiService = ApiService();
    Map<String, dynamic> userData = {
      'email': widget.email,
      'nickname': _nickname,
      'access_token': widget.token
    };
    print(userData);
    Response response = await _apiService.signupUser(userData);
    print(response);

    // shared preferences에 저장
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userData', response.data.toString());
    print('저장 완료?');

    setState(() {
      _errorMessage = null;
    });
  }
}
                        