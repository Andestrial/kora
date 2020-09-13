import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/screens/addInformationScreen.dart';
import 'package:kora/screens/authorizationScreen.dart';
import 'package:kora/services/database.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    bool isLoggedIn = user != null;
    if(isLoggedIn) {
      return DatabaseService().getUserInfo(user);
    }
    if(!isLoggedIn) return AuthorizationPage();
  }
}