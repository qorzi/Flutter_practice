import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:splash_login/home.dart';
import 'package:splash_login/login.dart';

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

  void _navigateToNextScreen() {
    final isLoggedIn = false; // 여기에 로그인 상태를 확인하는 로직을 구현합니다.

    if (isLoggedIn) {
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
