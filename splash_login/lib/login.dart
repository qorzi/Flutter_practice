import 'package:flutter/material.dart';

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
              left: MediaQuery.of(context).size.width / 2 - 109,
              child: Image.asset(
                'assets/main_logo_red_x1.png',
                // width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}