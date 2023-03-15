import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isError;

  CustomTextField({required this.onChanged, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextField(
        autofocus: true,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 16,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[ㄱ-ㅎ|ㅏ-ㅣ|가-힣a-zA-Z]')),
        ],
        onChanged: onChanged,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          suffix: isError
              ? Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Image.asset('assets/textFiled_incorrect.png'))
              : null,
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
    );
  }
}