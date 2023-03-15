import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:auth_test/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:auth_test/signup.dart';
import 'package:auth_test/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFF2E4D9),
        child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 191,
              right: MediaQuery.of(context).size.width / 2 - 109,
              child: Image.asset(
                'assets/main_logo_red_x1.png',
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 100,
              left: MediaQuery.of(context).size.width / 2 - 190,
              child: GestureDetector(
                onTap: () async{
                  signInWithGoogle(context); // 구글 로그인 리다이렉트
                },
                child: Image.asset(
                  'assets/google_login_btn.png',
                  width: 380,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



Future<void> signInWithGoogle(BuildContext context) async {
  final GoogleSignIn googleSignIn = GoogleSignIn(); // 구글 로그인 함수 불러오기
  print('로그인 시작!');
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    print('로그인 상태확인 $googleSignInAccount');
    if (googleSignInAccount == null) {
      // 사용자가 로그인 창을 닫거나 로그인을 취소한 경우
      print('사용자가 로그인을 취소했습니다.');
      return;
    }
    
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    print('토큰 수납!');
    print(googleSignInAuthentication.accessToken);
    String userToken = googleSignInAuthentication.accessToken.toString();

    print('유저정보 확인!');
    ApiService _apiService = ApiService();
    Map<String, dynamic> userData = {'access_token': userToken};
    Response? response  = await _apiService.loginUser(userData);
    print('응답: ${response.toString()}'); // {"message":"OK","status":200,"data":{"user_idx":null,"email":"xxxx@gmail.com","nickname":null,"jwtToken":null}}

    // 디코딩
    Map<String, dynamic> decodeRes = jsonDecode(response.toString());
    print('디코딩 : $decodeRes');

    if (decodeRes['data']['user_idx'] == null) {
      print('회원가입으로 이동!');
      String userEmail = decodeRes['data']['email'];
      Route signup = MaterialPageRoute(builder: (context) => SignUp(email: userEmail, token: userToken));
      Navigator.pushReplacement(context, signup);
    } else {
      print('로컬에 유저정보 저장!');
      // shared preferences에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userData', response.toString());

      print('홈으로 이동!');
      Route home = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, home);
    }
  } catch (error) {
    // 예외 처리
    print('구글 로그인 실패');
    print(error);
    return;
  }
}