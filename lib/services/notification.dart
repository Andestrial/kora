import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kora/core/constants/fcmServerToken.dart';
import 'package:kora/domain/user.dart';
import 'package:http/http.dart' as http;

class PushNotification {

  sendNotification(DocumentSnapshot snapshot, String modelName) {
    User user = User(
      deviceTokens: snapshot.data['deviceTokens'].cast<String>(),
      id: snapshot.data['id'],
      name: snapshot.data['name'],
      surname: snapshot.data['surname']
    );

    user.deviceTokens.forEach((element) {
      http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$fcmServerToken',
        },
        body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Користувач ${user.name} ${user.surname} добавив ваші $modelName в вибране',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': element,
        },
        ),
      );
    });
  }
}