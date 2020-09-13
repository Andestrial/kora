import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/oneLoginButton.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/startEllipse.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/startLogo.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/resources/fonts/my_flutter_app_icons.dart';
import 'package:kora/screens/varificationPhone.dart';
import 'package:kora/services/auth.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({Key key}) : super(key: key);

  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}
String verificationId;

class _AuthorizationPageState extends State<AuthorizationPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBground,
      body: Align(
        alignment: Alignment.center,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (OverscrollIndicatorNotification overscroll) {
            overscroll.disallowGlow();
            return;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                startLogo(),
                startEllipse(),
                _buttons()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttons() {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 27),
      child: Row(
        mainAxisAlignment:MainAxisAlignment.center,
        children: [
          Spacer(
            flex: 1,
          ),
          OneLoginButton(
            boxColor: Color.fromRGBO(66, 255, 0, 1), 
            shadowColor: Color.fromRGBO(66, 255, 0, 0.5), 
            insideIcon: CustomIcons.phone, 
            func: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => VarificationPhonePage()));
          }),
          Spacer(
            flex: 1,
          ),
          OneLoginButton(
            boxColor: Color.fromRGBO(68, 66, 155, 1), 
            shadowColor: Color.fromRGBO(68, 66, 155, 0.5), 
            insideIcon: CustomIcons.facebook, 
            func: () async {
            bool res = await AuthService().loginWithFacebook(context);
            if(!res){
              print('Error');
            }
          }),
          Spacer(
            flex: 1,
          ),
          OneLoginButton(
            boxColor: Color.fromRGBO(255, 0, 0, 1), 
            shadowColor: Color.fromRGBO(255, 0, 0, 0.5), 
            insideIcon: CustomIcons.google, 
            func: () async {
            bool res = await AuthService().loginWithGoogle();
            if(!res){
              print('Error');
            }
          }),
          Spacer(
            flex: 1,
          ),
        ],
      ),
    );
  }
}