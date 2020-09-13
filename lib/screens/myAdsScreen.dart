import 'package:flutter/material.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/header.dart';
import 'package:kora/resources/styles/rectangularIndicator.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/sneckersCard.dart';
import 'package:kora/domain/sneakers.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/services/database.dart';

class MyAdsScreen extends StatefulWidget {
  final String userId;
  MyAdsScreen({Key key, this.userId}) : super(key: key);

  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  List<Sneackers> archive = List<Sneackers>();
  List<Sneackers> active = List<Sneackers>();
  DatabaseService db = DatabaseService();

  @override
  void initState() {
    super.initState();
    loadAds();
  }

  loadAds() async {
    var archiveStream = db.getAdsFromArchive(widget.userId);
    var activeStream = db.getMyActiveAds(widget.userId);
    archiveStream.listen((data) { 
      setState(() {
        archive = data;
      });
    });
    activeStream.listen((data) { 
      setState(() {
        active = data;
      });
    });

  }

  final List tabs = <Widget>[
    Tab(text: 'Активні'),
    Tab(text: 'Архів'),
  ];

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
              child: DefaultTabController(
                length: tabs.length,
                child: Builder(
                  builder: (BuildContext context) {
                    return Column(
                      children: [
                        Container(
                          height: 35,
                          margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              width: 1,
                              color: Color.fromRGBO(75, 75, 75, 1),
                              style: BorderStyle.solid
                            )
                          ),
                          child: TabBar(
                            indicator: RectangularIndicator(
                              color: blueColor,
                              bottomLeftRadius: 50,
                              bottomRightRadius: 50,
                              topLeftRadius: 50,
                              topRightRadius: 50,
                            ),
                            tabs: tabs,
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              active.length <= 0 
                                ? Center(
                                    child: Text(
                                      'У вас поки немає \nактивних оголошень',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: active.length,
                                    itemBuilder: (context, int i) {
                                      return SneackersCard(sneackers: active[i], isFavorite: false);
                                    },
                                  ),
                              archive.length <= 0 
                                ? Center(
                                    child: Text(
                                      'У вас поки немає \nархівних оголошень',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 16
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: archive.length,
                                    itemBuilder: (context, int i) {
                                      return SneackersCard(sneackers: archive[i], isFavorite: false,);
                                    },
                                  ),
                            ]
                          ),
                        )
                      ],
                    );
                  }
                ),
              ),
            )
          ]
        )
      )
    );
  }
}