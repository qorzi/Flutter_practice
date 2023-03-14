import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:splash_login/home.dart';
import 'package:splash_login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(
    MaterialApp(
      home: SplashScreen(),
    ),
  );
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isMoved = false;
  bool _isVisible = false;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    // 1초 후에 _isMoved 값을 변경하여 애니메이션을 발생시킴
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isMoved = true;
      });
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          _isVisible = true;
        });
        // _navigateToNextScreen();
      });
      Future.delayed(Duration(seconds: 1), () {
        _navigateToNextScreen();
      });
    });
  }

  // 이미 로그인 되어 있는지 판단하고, 홈/로그인 분기합니다.
  void _navigateToNextScreen() async{
    // 데이터 가져오기
    Future<SharedPreferences> _sprefs = SharedPreferences.getInstance();
    _sprefs.then((prefs) {
      final String jsonString = prefs.getString('userData') ?? ''; // 기본값으로 빈 문자열을 사용합니다.
      final Map<String, dynamic> userData = json.decode(jsonString);
      setState(() {
        _isLoggedIn = userData['jwtToken'] == null ? false : true; // 여기에 로그인 상태를 확인하는 로직을 구현합니다.
      });
    },
    onError: (error) {
      print("SharedPreferences ERROR = $error");   
    });

    if (_isLoggedIn) {
      Route home = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushReplacement(context, home); // 로그인 상태이면 홈화면으로 이동합니다.
    } else {
      // Route login = MaterialPageRoute(builder: (context) => LoginScreen());
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          // 연결할 페이지
          pageBuilder: (c, a1, a2) => LoginScreen(),
          // 적용할 애니메이션
          transitionsBuilder: (c, a1, a2, child) => FadeTransition(opacity: a1, child: child),
          // 적용 시간 설정
          transitionDuration: Duration(milliseconds : 500),)); // 로그인 상태가 아니면 로그인화면으로 이동합니다.
          }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xFFD91604),
        child: Stack(
          children: [
            Center(
              child: TweenAnimationBuilder<double>(
                duration: Duration(milliseconds: 500),
                tween: Tween<double>(begin: 0, end: _isMoved ? -100 : 0),
                builder: (BuildContext context, double value, Widget? child) {
                  return Transform.translate(
                    offset: Offset(0, value),
                    child: child,
                  );
                },
                child: Image.asset(
                  'assets/main_logo_white_x1.png',
                  // width: 200,
                ),
              ),
            ),
            Positioned(
              bottom: 300,
              left: MediaQuery.of(context).size.width / 2 - 18,
              child: Visibility(
                visible: _isVisible,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
