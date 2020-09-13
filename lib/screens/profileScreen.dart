import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/header.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/mainButton.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/services/auth.dart';
import 'package:kora/services/database.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File image;
  bool loadingAvatar = false;
  
  Future loadImg(User user) async{
    image = await ImagePicker.pickImage(source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);
    if(image != null) {
      setState(() {
        loadingAvatar = true;
        DatabaseService().chooseAvatar(user, image).whenComplete(() => 
          setState(() {
            loadingAvatar = false;
          })
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Row(
                        children: [
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              Container(
                                width: 91,
                                height: 91,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: Image.network(user.urlAvatar).image
                                  ),
                                ),
                                child: loadingAvatar ? 
                                  Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                        blueColor
                                      ),
                                    )
                                  ) : 
                                  Container(),
                              ),
                              Transform.translate(
                                offset: Offset(5, 5),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(50),
                                  onTap: () {
                                    loadImg(user);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: blueColor
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Transform.translate(
                            offset: Offset(0, -7),
                            child: Container(
                              margin: EdgeInsets.only(left: 12),
                              child: Text(
                                user.name + ' ' + user.surname,
                                style: TextStyle(
                                  fontSize: 22,
                                  color: textColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 35),
                      child: Text(
                        'Контактний номер',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14
                        ),
                      ),
                    ),
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(text: user.phone),
                      enabled: false,
                      decoration: InputDecoration(
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: descriptionColor.withOpacity(0.3),
                            width: 1
                          )
                        )
                      ),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 35),
                      child: Text(
                        'Місто',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 14
                        ),
                      ),
                    ),
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(text: user.city),
                      enabled: false,
                      decoration: InputDecoration(
                        disabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: descriptionColor.withOpacity(0.3),
                            width: 1
                          )
                        )
                      ),
                      style: TextStyle(
                        color: textColor,
                        fontSize: 18
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 40, left: 32, right: 32),
                      child: MainButton(
                        insideText: 'Вийти', 
                        func: () {
                        AuthService().logOut();
                      })
                    )
                  ],
                ),
              ),
            )
          ]
        )
      )
    );
  }
}