import 'package:flutter/material.dart';
import 'package:dio/dio.dart'; // Response 가져오기 위함.
import 'package:splash_login/api_service.dart';

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
            Positioned(
              top: MediaQuery.of(context).size.height / 2 + 100,
              left: MediaQuery.of(context).size.width / 2 - 190,
              child: GestureDetector(
                onTap: () async{
                  ApiService _apiService = ApiService();
                  // GET 메서드 호출
                  Response response = await _apiService.getUser(2);
                  print(response);

                  // POST 메서드 호출
                  // Map<String, dynamic> userData = {'name': 'John Doe', 'email': 'johndoe@example.com'};
                  // Response postUserResponse = await _apiService.postUser(userData);

                  // PUT 메서드 호출
                  // Map<String, dynamic> updatedUserData = {'name': 'John Doe Jr.'};
                  // Response putUserResponse = await _apiService.putUser(2, updatedUserData);
                },
                child: Image.asset(
                  'assets/google_login_btn.png',
                  width: 380,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}