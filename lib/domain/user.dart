import 'package:firebase_auth/firebase_auth.dart';

class User {
  String id;
  String name;
  String surname;
  String phone;
  String city;
  String urlAvatar;
  List<String> favoritesId = [];
  List<String> deviceTokens = [];

  User.fromFirebase(FirebaseUser fuser) {
    id = fuser.uid;
  }

  User.fromJson(String id, Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    surname = data['surname'];
    phone = data['phone'];
    city = data['city'];
    urlAvatar = data['avatar'];
    favoritesId = data['favoritesId'];
    deviceTokens = data['deviceTkens'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'surname': surname,
      'phone': phone,
      'city': city,
      'urlAvatar': urlAvatar,
      'favoritesId': favoritesId,
      'deviceTokens' : deviceTokens
    };
  }

  User({
    this.id, 
    this.name, 
    this.surname, 
    this.phone, 
    this.city, 
    this.urlAvatar, 
    this.favoritesId, 
    this.deviceTokens
  });
}