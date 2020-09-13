import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/screens/authorizationScreen.dart';
import 'package:kora/screens/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:kora/services/database.dart';

class AuthService {

  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  User user = User();

  Future<bool> loginWithFacebook(BuildContext context) async{
    try {
      FacebookLogin facebookLogin = FacebookLogin();
      FacebookLoginResult account = await facebookLogin.logIn(['email']);
      String token = account.accessToken.token;
      AuthResult res;
      if(account == null) {
        return false;
      }

      final userResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');

      if (userResponse.statusCode == 200){
        final profile = await json.decode(userResponse.body);
        user = User(
          name: profile['first_name'],
          surname: profile['last_name'],
          urlAvatar: 'http://graph.facebook.com/${profile['id']}/picture',
        );
        if(account.status == FacebookLoginStatus.loggedIn){
          res = await signIn(FacebookAuthProvider.getCredential(accessToken: token));
        }
      }
      if(res.user == null) {
        return false;
      }else {
        return true;
      }
    }catch(e) {
      print(e.message);
      print("Error logging with facebook");
      return false;
    }
  }

  Future<bool> loginWithGoogle() async{
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount account = await googleSignIn.signIn();
      String token = (await account.authentication).idToken;
      String accessToken = (await account.authentication).accessToken;
      AuthResult res;

      if(account == null) {
        return false;
      }
      final userResponse = await http.get(
          'https://www.googleapis.com/oauth2/v1/userinfo?alt=json&access_token=${accessToken}');
      if (userResponse.statusCode == 200){
        final profile = await json.decode(userResponse.body);

        user = User(
          name: profile['given_name'],
          surname: profile['family_name'],
          urlAvatar: profile['picture'],
        );
        
        res = await signIn(GoogleAuthProvider.getCredential(
          idToken: token,
          accessToken: accessToken,
        ));
        
      }
      if(res.user == null){
        return false;
      }else{
        return true;
      }
    }catch(e) {
      print(e.message);
      print("Error logging with google");
      return false;
    }
  }

  Future<AuthCredential> verifyPhone(String phoneNumber) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieval = (String verId) {
      verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeSend]) {
      verificationId = verId;
    }; 

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential authResult) async{

    };

    final PhoneVerificationFailed verifiFailed = (AuthException authException) {
      print('Lol + ${authException.message}');
    };
    
    await _fAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber, 
      timeout: Duration(seconds: 60), 
      verificationCompleted: verifiedSuccess, 
      verificationFailed: verifiFailed, 
      codeSent: smsCodeSent, 
      codeAutoRetrievalTimeout: autoRetrieval
    );
    
  }

  signIn(AuthCredential authCredential) async {
    await _fAuth.signInWithCredential(authCredential);
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool isTr = await DatabaseService().getUserDoc(currentUser.uid);
    isTr ? null : await DatabaseService().addUserInfo(currentUser.uid, user);
  }

  Future<AuthCredential> signInWithOTP(smsCode, verId) async{
    return PhoneAuthProvider.getCredential(verificationId: verId, smsCode: smsCode); 
  }

  Future logOut() async {
    var user = await _fAuth.currentUser();
    DatabaseService().removeDeviceToken(user.uid);
    await _fAuth.signOut();
    await GoogleSignIn().signOut();
    await FacebookLogin().logOut();
  }

  Stream<User> get currentUser{
    return _fAuth.onAuthStateChanged
      .map((FirebaseUser user) => user != null ? User.fromFirebase(user) : null);
  }
}