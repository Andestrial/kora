import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/mainButton.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/startEllipse.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/startLogo.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/startTextField.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/screens/authorizationScreen.dart';
import 'package:kora/services/auth.dart';

class VarificationPhonePage extends StatefulWidget {
  VarificationPhonePage({Key key}) : super(key: key);

  @override
  _VarificationPhonePageState createState() => _VarificationPhonePageState();
}

class _VarificationPhonePageState extends State<VarificationPhonePage> {
  
  TextEditingController _phoneController = TextEditingController(text: '+380');
  TextEditingController _codeController = TextEditingController();

  String smsCode;
  String phoneNumber;
  bool sentCode = false;

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
                _form(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _form() {
    return 
    sentCode 
    ? Container(
        margin: EdgeInsets.only(left: 40, right: 40 , bottom: 40),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: StartTextField(
                controller: _codeController
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: MainButton(
                insideText: 'Далі', 
                func: () async{
                  this.smsCode = _codeController.text;
                  await AuthService().signInWithOTP(smsCode, verificationId)
                    .then((authCredential) async => await AuthService().signIn(authCredential));
                    Navigator.pop(context);
                  _phoneController.clear();
              }),
            )
          ],
        ),
      )
    : Container(
      margin: EdgeInsets.only(left: 40, right: 40 , bottom: 40),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: StartTextField(
              controller: _phoneController),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35),
            child: MainButton(
              insideText: 'Варифікувати', 
              func: () async {
                setState(() {
                  sentCode = true;
                });
                this.phoneNumber = _phoneController.text;
                await AuthService().verifyPhone(phoneNumber);
                _phoneController.clear();
              }
            ),
          )
        ],
      ),
    );
  }
}