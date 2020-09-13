import 'package:flutter/material.dart';
import 'package:kora/resources/colors/colors.dart';

Widget startEllipse() {
  return Container(
    child: Stack(
      alignment: Alignment.center,
      children: [
        Image(
          image: AssetImage('lib/resources/images/ellipse.png'),
        ),
        Text(
          'Вхід',
          style: TextStyle(
            color: textColor,
            fontSize: 28  
          ),
        )
      ]
    ),
  );
}