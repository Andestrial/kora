import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/header.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/sneckersCard.dart';
import 'package:kora/domain/filter.dart';
import 'package:kora/domain/sneakers.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/resources/fonts/my_flutter_app_icons.dart';
import 'package:kora/resources/styles/filterAnimation.dart';
import 'package:kora/resources/styles/filter.dart';
import 'package:kora/services/database.dart';


class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  StreamController<FilterData> controller = StreamController<FilterData>();

  List<Sneackers> ads = List<Sneackers>();
  List<Sneackers> adsOnline = List<Sneackers>();
  DatabaseService db = DatabaseService();

  @override
  void initState() {
    DatabaseService().addDeviceToken();
    loadAds();
    controller.stream.listen((event) { 
      filter(fData: event);
    });
    super.initState();
  }

  void filter({FilterData fData}) {
    List filter = adsOnline;
    if (fData != null) {
      if(fData.model != null && fData.model.isNotEmpty) {
        filter = filter.where((element) => element.modelName == fData.model).toList();
      } if(fData.material != null && fData.material.isNotEmpty) {
        filter = filter.where((element) => element.material == fData.material).toList();
      } if(fData.sizeFrom != null) {
        filter = filter.where((element) => element.size >= fData.sizeFrom).toList();
      } if(fData.sizeTo != null) {
        filter = filter.where((element) => element.size <= fData.sizeTo).toList();
      } if(fData.priceFrom != null) {
        filter = filter.where((element) => element.price >= fData.priceFrom).toList();
      } if(fData.priceTo != null) {
        filter = filter.where((element) => element.price <= fData.priceTo).toList();
      } 
      setState(() {
        ads = filter;
      });
    }else {
      loadAds();
    }
  }
  
  loadAds() {
    var stream = db.getAds();
    stream.listen((data) { 
      setState(() {
        ads = data;
        adsOnline = data;
      });
    });
  }

  @override
  Widget build(BuildContext contextt) {
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
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 23, bottom: 5, top: 5),
                      child: InkWell (
                        child: Icon(
                          CustomIcons.filter,
                          color: Colors.white,
                          size: 15,
                        ),
                        onTap: () {
                          FilterAnimation().animation(
                            context, 
                            Filter(
                              controller: controller
                            )
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: ads.length,
                      itemBuilder: (context, i) {
                        return SneackersCard(
                          sneackers: ads[i], 
                          isFavorite: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}