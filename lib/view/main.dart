import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/screens/landingPage.dart';
import 'package:kora/services/auth.dart';
import 'package:kora/view/portraitModeOnly.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(KoraApp());
}

class KoraApp extends StatelessWidget with PortraitModeMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamProvider<User>.value(
      value: AuthService().currentUser, 
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kora',
        home: LandingPage()
      )
    );
  }
}
