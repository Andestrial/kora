import 'package:flutter/material.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/header.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/sneckersCard.dart';
import 'package:kora/domain/sneakers.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/screens/mainScreen.dart';
import 'package:kora/services/database.dart';

class FavoriteScreen extends StatefulWidget {
  final String userId;
  FavoriteScreen({Key key, this.userId}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  
  List<Sneackers> favorite = List<Sneackers>();
  DatabaseService db = DatabaseService();
  
  @override
  void initState() {
    super.initState();
    loadAds();
  }

  loadAds() async {
    var favoriteStream = db.getFavorite(widget.userId);
    favoriteStream.listen((data) { 
      setState(() {
        favorite = data;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainBground,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
          return;
        },
        child: Stack(
          children: [
            Header(),
            SafeArea(
              child: ListView.builder(
                itemCount: favorite.length,
                itemBuilder: (context, int i) {
                  return SneackersCard(
                    sneackers: favorite[i], 
                    isFavorite: true
                  );
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}
