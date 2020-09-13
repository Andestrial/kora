import 'package:flutter/material.dart';

class OneLoginButton extends StatelessWidget {
  Color boxColor;
  Color shadowColor;
  IconData insideIcon;
  Function func;

  OneLoginButton({
    Key key,
    this.boxColor,
    this.func,
    this.insideIcon,
    this.shadowColor
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10
            )
          ]
        ),
        child: Icon(
          insideIcon,
          color: Colors.white,
          size: 25,
        ),
      ),
      onTap: () {
        func();
      },
    );
  }
}

Widget oneLoginButton(Color boxColor, Color shadowColor, IconData insideIcon, void func()) {
  return InkWell(
    borderRadius: BorderRadius.circular(25),
    child: Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10
          )
        ]
      ),
      child: Icon(
        insideIcon,
        color: Colors.white,
        size: 25,
      ),
    ),
    onTap: () {
      func();
    },
  );
}