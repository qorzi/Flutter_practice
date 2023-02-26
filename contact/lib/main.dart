import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: MyApp()
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var count = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('버튼'),
        onPressed: (){
            showDialog(context: context, builder: (context){
              return DialogUI(count : count);
            });
        }
      ),
      appBar: AppBar( title: Text('이거슨 플러터란 것이다.')),
      body: ListView.builder(
        itemCount: count,
        itemBuilder: (context, index) {
          return Text('반복해서 만들어$index');
        },
      )
    );
  }
}

class DialogUI extends StatefulWidget {
  DialogUI({Key? key, this.count}) : super(key: key);
  final count;

  @override
  State<DialogUI> createState() => _DialogUIState();
}

class _DialogUIState extends State<DialogUI> {
  var inputData2 = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300,
        height: 300,
        child: Column(
          children: [
            Text(inputData2),
            TextField(onChanged: (text){setState((){inputData2 = text;});}),
            Row(
              children: [
                TextButton(onPressed: (){}, child: Text('완료')),
                TextButton(onPressed: (){ Navigator.pop(context);}, child: Text('취소')),
              ],
            )
          ],
        )
      ),
    );
  }
}
