import 'package:firebase_messaging/firebase_messaging.dart';

Future<String> deviceTOken = FirebaseMessaging().getToken();