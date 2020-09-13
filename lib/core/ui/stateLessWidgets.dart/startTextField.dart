import 'package:flutter/material.dart';
import 'package:kora/resources/colors/colors.dart';


class StartTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const StartTextField({
    Key key,
    this.controller,
    this.hint
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField( 
      enableInteractiveSelection: false,
      textAlignVertical: TextAlignVertical.center,
      autofocus: false,
      controller: controller,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 21),
        hintText: hint,
        hintStyle: TextStyle(
          color: textColor,
          fontSize: 16
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.white54,
            width: 1
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.white54,
            width: 2
          )
        ),
      ),
    );
  }
}