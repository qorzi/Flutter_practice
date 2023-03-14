import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:splash_login/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:splash_login/signup.dart';
import 'package:splash_login/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> signInWithGoogle(BuildContext context) async {
  print('로그인!');
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
  print(googleSignInAccount);
  final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

  print('토큰 수납!');
  print(googleSignInAuthentication.accessToken);
  String userToken = googleSignInAuthentication.accessToken.toString();

  print('유저정보 확인!');
  ApiService _apiService = ApiService();
  Map<String, dynamic> userData = {'access_token': userToken};
  Response response = await _apiService.loginUser(userData);
  print(response);
  // print(response.data);
  // print(response.data.runtimeType);
  // JSON 문자열을 Map으로 변환
  // Map<String, dynamic> jsonMap = json.decode(response.data);
  if (response.data['user_idx'] == null) {
    String userEmail = response.data['email'];
    Route signup = MaterialPageRoute(builder: (context) => SignUp(email: userEmail, token: userToken));
    Navigator.pushReplacement(context, signup);
  }
  print('pass');
  // shared preferences에 저장
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userData', response.data.toString());
  print('저장완료?');

  Route home = MaterialPageRoute(builder: (context) => HomeScreen());
  Navigator.pushReplacement(context, home);
}

Future<void> signOutGoogle() async{
  await googleSignIn.signOut();
  print('로그아웃!');
}

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
                // width: 200,
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
            // Positioned(
            //   top: MediaQuery.of(context).size.height / 2 + 60,
            //   left: MediaQuery.of(context).size.width / 2 - 190,
            //   child: TextButton(onPressed: (){
            //     signOutGoogle();
            //   }, child: Text('로그아웃')),
            // )
          ],
        ),
      ),
    );
  }
}