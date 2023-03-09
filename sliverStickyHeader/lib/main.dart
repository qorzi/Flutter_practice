import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text('TEST 페이지입니다.', style: TextStyle(fontSize: 20))
            ],
          ),
        ),
      ),
    );
  }
}
