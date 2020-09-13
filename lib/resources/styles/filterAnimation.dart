import 'package:flutter/material.dart';

class FilterAnimation {
  animation(BuildContext context, Widget filter){
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: true,
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return filter;
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}


