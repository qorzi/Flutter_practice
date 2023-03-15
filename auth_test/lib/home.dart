import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_test/login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async{
            final prefs = await SharedPreferences.getInstance();
            final success = await prefs.remove('userData');
            signOutGoogle();
            print('로그인 정보 삭제 완료!');
            Route login = MaterialPageRoute(builder: (context) => LoginScreen());
            Navigator.pushReplacement(context, login);
          },
          child: Text('로그아웃')
        ),
      ),
    );
  }
}

Future<void> signOutGoogle() async{
  final GoogleSignIn googleSignIn = GoogleSignIn(); // 구글 로그인 함수 불러오기
  await googleSignIn.signOut();
  print('로그아웃!');
}