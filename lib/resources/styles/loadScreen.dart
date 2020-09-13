import 'package:flutter/material.dart';
import 'package:kora/resources/colors/colors.dart';

class LoadScreen extends StatelessWidget {
  const LoadScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBground,
      body: Center(
        child: CircularProgressIndicator(
          valueColor:  AlwaysStoppedAnimation(
            blueColor
          ),
        ),
      ),
    );
  }
}