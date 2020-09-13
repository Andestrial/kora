import 'package:flutter/material.dart';
import 'package:kora/resources/colors/colors.dart';

class AdsLoader extends StatelessWidget {
  const AdsLoader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: mainBground,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircularProgressIndicator(
            valueColor:  AlwaysStoppedAnimation(
              blueColor
            ),
          ),
          Text(
            'Додаємо оголошення',
            style: TextStyle(
              color: textColor,
              fontSize: 20
            ),
          ),
        ],
      )
    );
  }
}