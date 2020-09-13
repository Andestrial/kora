import 'package:flutter/material.dart';
import 'package:kora/resources/styles/deleteAlert.dart';
import 'package:kora/core/ui/stateFullWidgets.dart/detailCard.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/mainButton.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/sellerInfo.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/resources/styles/loadScreen.dart';
import 'package:kora/services/database.dart';
import 'package:provider/provider.dart';


class DetailsScreen extends StatefulWidget {
  final String sneackersId;
  final String authorId;
  DetailsScreen({Key key, @required this.sneackersId, @required this.authorId}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  User seller;
  User user;
  bool isUserAd = false;
  bool isArchive = false;
  bool loader = true;
  String sneackersId;
  String authorId;

  @override
  void initState() {
    sneackersId = widget.sneackersId;
    authorId = widget.authorId;
    check();
    super.initState();
  }

  check() async {
    seller = await DatabaseService().info(authorId);
    isArchive = await DatabaseService().getArchiveDoc(authorId, sneackersId);
      setState(() {
        isUserAd = seller.id == user.id;
        loader = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<User>(context);
    return loader 
      ? LoadScreen()
      : Scaffold(
        backgroundColor: mainBground,
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
              ),
              DetailCard(
                sneackersId: sneackersId,
                authorId: authorId,
                isArchive: isArchive,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: isUserAd 
                ? Visibility(
                    visible: !isArchive,
                    child: Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40, bottom: 35, top: 30),
                    child: MainButton(
                      insideText: 'Видалити',
                      func: () {
                        alertDialoge(context, sneackersId, authorId);
                      },
                    ),
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 20, right: 15, top: 20),
                  child: SellerInfo(
                    seller: seller
                  ),
                ),
              )
            ],
          ),
        ),
      );
  }
}