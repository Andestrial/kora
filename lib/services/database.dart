
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:kora/core/constants/fcmDeviceToken.dart';
import 'package:kora/domain/filter.dart';
import 'package:kora/domain/sneakers.dart';
import 'package:kora/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:kora/screens/addInformationScreen.dart';
import 'package:kora/screens/homePage.dart';
import 'package:kora/services/notification.dart';
import 'package:provider/provider.dart';

class DatabaseService{
  final FirebaseMessaging _fcm = FirebaseMessaging();
  final CollectionReference _usersCollection = Firestore.instance.collection('Users');
  final CollectionReference _sneackersCollection = Firestore.instance.collection('Ads');
  final CollectionReference _archiveCollection = Firestore.instance.collection('Archive');
  final CollectionReference _myActiveCollection = Firestore.instance.collection('Active');
  final CollectionReference _favoriteCollection = Firestore.instance.collection('Favorite');

  Future addUserInfo(String id, User user) async {
    await _usersCollection.document(id).setData(user.toJson());
  }

   Future updateUserInfo(String id, User user) async {
    await _usersCollection.document(id).updateData(user.toJson());
  }

  Future<String> createAd() async{
    var doc = _sneackersCollection.document();
    return doc.documentID;
  }

  Future addAdInfo(Sneackers sneackers) async {
    DocumentReference adRef = _sneackersCollection.document(sneackers.id);

    return adRef.setData(sneackers.toJson()).then((_) async{
      await _myActiveCollection.document(sneackers.authorId).collection('Sneackers').document(sneackers.id).setData(sneackers.toJson());
    });
  }

  Future addAvatar(User user) async {
    await _usersCollection.document(user.id).updateData(user.toJson());
  }

  Stream userInfoStream(String id) {
    return _usersCollection.document(id).snapshots();
  }

  Future copyToArchive(String sneackersId, String authorId) async{
    var doc = await _sneackersCollection.document(sneackersId).get();
    var sneackers = Sneackers.fromJson(doc.documentID, doc.data);
    return _archiveCollection.document(authorId).collection('Sneackers').document(sneackersId).setData(sneackers.toJson());
  }

  Future addDeviceToken() async {
    var user = await FirebaseAuth.instance.currentUser();
    String token = await deviceTOken;
    return _usersCollection.document(user.uid).updateData({'deviceTokens': FieldValue.arrayUnion([token])});
  }

  Future removeDeviceToken(String uid) async{
    String token = await deviceTOken;
    return _usersCollection.document(uid).updateData({'deviceTokens': FieldValue.arrayRemove([token])});
  }

  Future addFavorite(String uid, Sneackers sneackers) async {
    _favoriteCollection.document(uid).collection('Sneackers').document(sneackers.id).setData(sneackers.toJson());
    _usersCollection.document(uid).updateData({'favoritesId': FieldValue.arrayUnion([sneackers.id])});
    var document = _usersCollection.document(sneackers.authorId);
    var snapshot = await document.get();
    PushNotification().sendNotification(snapshot, sneackers.modelName);
  }

  Future removeFavorite(String uid, Sneackers sneackers) {
    return _favoriteCollection.document(uid).collection('Sneackers').document(sneackers.id).delete().then((_) => 
      _usersCollection.document(uid).updateData({'favoritesId': FieldValue.arrayRemove([sneackers.id])}));
  }

  Future deleteAd(String sneackersId, String authorId) {
    _sneackersCollection.document(sneackersId).delete();
    _myActiveCollection.document(authorId)
      .collection('Sneackers').document(sneackersId).delete();
  }

  Future<String> addImages(User user, File image, String docId) async {    
    FirebaseStorage _storage = FirebaseStorage.instance;
    StorageReference reference = _storage.ref().child("Ads/${user.id}/${docId}/${DateTime.now()}");
    StorageUploadTask uploadTask = reference.putFile(image);
    await uploadTask.onComplete;
    var fileURL = await reference.getDownloadURL();
    return fileURL.toString();
  }

  Future chooseAvatar(User user, File image) async {    
    FirebaseStorage _storage = FirebaseStorage.instance;
    StorageReference reference = _storage.ref().child("Avatars/${user.id}");
    StorageUploadTask uploadTask = reference.putFile(image);
    await uploadTask.onComplete;
    reference.getDownloadURL().then((fileURL){
      user.urlAvatar = fileURL.toString();
      DatabaseService().addAvatar(user);
    });
  }

  Future<bool> getUserDoc(String id) async {
    var docRef = _usersCollection.document(id);
    var doc = await docRef.get();
      try{
        if (doc.exists) {
          return true;
        }else {
          return false;
        }
      }catch(e){
        return false;
      }
  }

  Future<bool> getArchiveDoc(String authorId, String sneackersId) async {
    var docRef = _archiveCollection.document(authorId).collection('Sneackers').document(sneackersId);
    var doc = await docRef.get();
      try{
        if (doc.exists) {
          return true;
        }else {
          return false;
        }
      }catch(e){
        return false;
      }
  }

  Future<User> info(String id) async{
    var document = _usersCollection.document(id);
    var snapshot = await document.get();
    var info = User(
      id: snapshot.data['id'],
      name: snapshot.data['name'],
      surname: snapshot.data['surname'],
      city: snapshot.data['city'],
      phone: snapshot.data['phone'],
      urlAvatar: snapshot.data['urlAvatar'],
    );
    return info;
  }

  getUserInfo(User user) {
    return StreamBuilder (
      stream: userInfoStream(user.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data.data == null){
            return AddInformation();
          }
          user.name = snapshot.data.data['name'];
          user.surname = snapshot.data.data['surname'];
          user.city = snapshot.data.data['city'];
          user.phone = snapshot.data.data['phone'];
          user.urlAvatar = snapshot.data.data['urlAvatar'];
          user.favoritesId = snapshot.data.data['favoritesId'] != null ? snapshot.data.data['favoritesId'].cast<String>() : null;
          if(user.city == null || user.city.isEmpty || user.name == null || user.name.isEmpty ||user.surname == null || user.surname.isEmpty || user.phone == null || user.phone.isEmpty){
            return AddInformation();
          }
        }
        return HomePage();
      }
    );
  }

  Stream<Sneackers> getOneAd(String sneackersId, String authorId, bool isArchive) {
    DocumentReference docRef;
    if(isArchive) docRef = _archiveCollection.document(authorId).collection('Sneackers').document(sneackersId);
    else docRef = _sneackersCollection.document(sneackersId);

    return docRef.snapshots().map((DocumentSnapshot doc) => 
        Sneackers.fromJson(doc.documentID, doc.data));
  }

  Stream<List<Sneackers>> getAds() {
    Query query = _sneackersCollection;
    return query.snapshots().map((QuerySnapshot data) => 
      data.documents.map((DocumentSnapshot doc) => 
        Sneackers.fromJson(doc.documentID, doc.data)
        ).toList()
    );
  }

  Stream<List<Sneackers>> getAdsFromArchive(String uid) {
    Query query = _archiveCollection.document(uid).collection('Sneackers');
    return query.snapshots().map((QuerySnapshot data) => 
      data.documents.map((DocumentSnapshot doc) => 
        Sneackers.fromJson(doc.documentID, doc.data)
        ).toList()
    );
  }

  Stream<List<Sneackers>> getFavorite(String uid) {
    Query query = _favoriteCollection.document(uid).collection('Sneackers');
    return query.snapshots().map((QuerySnapshot data) => 
      data.documents.map((DocumentSnapshot doc) => 
        Sneackers.fromJson(doc.documentID, doc.data)
        ).toList()
    );
  }

  Stream<List<Sneackers>> getMyActiveAds(String uid) {
    Query query = _myActiveCollection.document(uid).collection('Sneackers');
    return query.snapshots().map((QuerySnapshot data) => 
      data.documents.map((DocumentSnapshot doc) => 
        Sneackers.fromJson(doc.documentID, doc.data)
        ).toList()
    );
  }
}