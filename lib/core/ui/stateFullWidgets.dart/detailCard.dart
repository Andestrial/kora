import 'package:flutter/material.dart';
import 'package:kora/core/ui/stateFullWidgets.dart/imageSlider.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/sizeBlock.dart';
import 'package:kora/domain/sneakers.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/resources/fonts/my_flutter_app_icons.dart';
import 'package:kora/screens/addAndUpdateAdScreen.dart';
import 'package:kora/resources/styles/loadScreen.dart';
import 'package:kora/services/database.dart';
import 'package:provider/provider.dart';

class DetailCard extends StatefulWidget {
  final String sneackersId;
  final String authorId;
  final bool isArchive;
  DetailCard({
    Key key,
    this.sneackersId,
    this.authorId,
    this.isArchive
  }) : super(key: key);

  @override
  _DetailCardState createState() => _DetailCardState();
}

class _DetailCardState extends State<DetailCard> {
  User user;
  Sneackers sneackers = Sneackers();
  List img= [];
  bool alreadySaved;
  bool loader = true;
  bool isArchive;
  String sneackersId;
  String authorId;
  @override
  void initState() {
    sneackersId = widget.sneackersId;
    authorId = widget.authorId;
    isArchive = widget.isArchive;
    loadAd();
    super.initState();
  }

  loadAd() async{
    var stream = DatabaseService().getOneAd(sneackersId, authorId, isArchive);
    stream.listen((data) { 
      sneackers = data;
      sneackers.images.forEach((element) {
        img.add(Image.network(element));
      });
      setState(() {
        loader = false;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    if(user.favoritesId != null) {
      alreadySaved = user.favoritesId.contains(sneackersId);
    }  
    return loader 
      ? LoadScreen()
      : Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(52, 52, 52, 1),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50),
          topLeft: Radius.circular(50),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              ImageSlider(images: img),
              IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: 15, bottom: 10, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 5, bottom: 9),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        child: Text(
                          sneackers.price.toStringAsFixed(0) + ' \$',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(67, 67, 67, 1)
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !isArchive,
                        child: user.id == sneackers.authorId 
                        ? IconButton(
                            icon: Icon(
                              CustomIcons.edit,
                              color: Colors.white,
                              size: 25,
                            ),
                            splashRadius: 1,
                            onPressed: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AddAndUpdateAdScreen(updateSneackers: sneackers);
                                  }
                                )
                              );
                            }
                          )
                        : alreadySaved
                            ? IconButton(
                                color: Colors.white,
                                splashRadius: 1,
                                icon: Icon(
                                  CustomIcons.favorite,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: () async {
                                  await DatabaseService().removeFavorite(user.id, sneackers).whenComplete(() => 
                                    setState(() {
                                      alreadySaved = user.favoritesId.contains(sneackersId);
                                    })
                                  );
                                }
                              )
                            : IconButton(
                                color: Colors.white,
                                splashRadius: 1,
                                icon: Icon(
                                  CustomIcons.favorite,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () {
                                  DatabaseService().addFavorite(user.id, sneackers).whenComplete(() => setState(() {
                                      alreadySaved = user.favoritesId.contains(sneackersId);
                                    })
                                  );
                                }
                              ))
                      
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Text(
                    sneackers.modelName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 22
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Text(
                    'Розмір стопи: ',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 10
                    ),
                  ),
                ),
                SizeBlock(
                  size: sneackers.size,
                  length: sneackers.length,
                  width: sneackers.width,
                  typeSize: sneackers.typeSize,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: Text(
                    'Матеріал: ' + sneackers.material,
                    style: TextStyle(
                      fontSize: 10,
                      color: materialColor
                    ),
                  ),
                ),
                Text(
                  sneackers.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: descriptionColor
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}