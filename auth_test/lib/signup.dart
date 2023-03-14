import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:auth_test/api_service.dart';
import 'package:flutter/services.dart'; // 정규식 메서드 가져오기
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_test/home.dart';

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
                      SizedBox(
                        width: double.infinity,
                        child: TextField(
                          autofocus: true, // 자동 포커싱
                          textAlignVertical: TextAlignVertical.center, // 수직 방향 중앙 정렬
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
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            suffix: _isError ? Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Image.asset('assets/textFiled_incorrect.png')
                            ) : null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Color(0xFFD91604), width: 4.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              borderSide: const BorderSide(color: Color(0xFFD91604), width: 4.0),
                            ),
                          ),
                        ),
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
      ),
    );
  }
  
  Future<void> _signUp(BuildContext context) async {

    // 유효성 검증
    if (_nickname == null) {
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
    print(userData); // 데이터 확인
    Response? response = await _apiService.signupUser(userData);
    print('응답: $response');

    // 상태 분기
    if (response?.statusCode == 409) {
      // 중복 닉네임 에러 409
      print('이미 존재하는 이메일 or 이미 존재하는 닉네임인 경우');

      setState(() {
        _errorMessage = response.toString();
        _isError = true;
      });

      return;
    } else if (response?.statusCode == 201) {
      // shared preferences에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', response!.data.toString());
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
                        