
import 'package:flutter/material.dart';
import 'package:kora/resources/colors/colors.dart';

class MainButton extends StatelessWidget {
  final String insideText;
  final Function func;

  const MainButton({
    Key key,
    this.insideText,
    this.func
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: blueColor
        ),
        child: Text(
          insideText,
          style: TextStyle(
            color: textColor,
            fontSize: 16
          ),  
        ),
      ),
      onTap: () {
        func();
      }
    );
  }
}


  

  