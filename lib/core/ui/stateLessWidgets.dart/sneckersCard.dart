import 'package:flutter/material.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/sizeBlock.dart';
import 'package:kora/domain/sneakers.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/screens/detailsScreen.dart';
import 'package:kora/services/database.dart';
import 'package:provider/provider.dart';

class SneackersCard extends StatelessWidget {
  final Sneackers sneackers;
  final isFavorite;
  SneackersCard({Key key, @required this.sneackers, @required this.isFavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    bool alreadySaved = false;
    bool isMy = false;

    if(user.favoritesId != null) {
      alreadySaved = user.favoritesId.contains(sneackers.id);
    }
    if(user.id == sneackers.authorId){
      isMy = true;
    }
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Color.fromRGBO(52, 52, 52, 1),
        borderRadius: BorderRadius.circular(10)
      ),
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: (context) => new DetailsScreen(sneackersId: sneackers.id, authorId: sneackers.authorId,)));
        },
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: Image.network(sneackers.images[0]).image
                    )
                  ),
                ),
                Visibility(
                  visible: !isMy,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: InkWell(
                      child: Icon(
                        Icons.favorite,
                        color: alreadySaved ? Colors.red : Colors.white,
                      ),
                      onTap: () {
                        alreadySaved
                          ? DatabaseService().removeFavorite(user.id, sneackers)
                          : DatabaseService().addFavorite(user.id, sneackers);
                      },
                    ),
                  ),
                )
              ]
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 40),
                          child: Text(
                            sneackers.modelName,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16
                            ),
                            ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 9, bottom: 9),
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
                        Text(
                          'Матеріал: ' + sneackers.material,
                          style: TextStyle(
                            fontSize: 10,
                            color: Color.fromRGBO(154, 154, 154, 1)
                          ),
                        )
                      ],
                    )
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Transform.translate(
                      offset: Offset(5, 0),
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(
                          sneackers.price.toStringAsFixed(0) + ' \$',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(67, 67, 67, 1)
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}


