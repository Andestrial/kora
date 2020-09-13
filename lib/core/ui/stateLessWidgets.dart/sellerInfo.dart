import 'package:flutter/material.dart';
import 'package:kora/domain/user.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/resources/fonts/my_flutter_app_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerInfo extends StatelessWidget {
  final User seller;
  const SellerInfo({Key key, this.seller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children:[
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: seller.urlAvatar != null 
                ? CircleAvatar(
                  backgroundImage: Image.network(seller.urlAvatar).image,
                  radius: 30,
                ) 
                : Container(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  seller.name,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 22
                  ),
                ),
                Text(
                  seller.city,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10
                  ),
                ),
              ],
            )
          ],
        ),
        Transform.rotate(
          angle: -3.14/4,
          child: InkWell(
            borderRadius: BorderRadius.circular(13),
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async{
              if(await canLaunch("tel:${seller.phone}")) {
                await launch("tel:${seller.phone}");
              }else {
                throw 'Could not launch ${seller.phone}';
              }
            },
            child: Ink(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: blueColor,
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: blueColor.withOpacity(0.4),
                    blurRadius: 15
                  )
                ]
              ),
              child: Transform.rotate(
                angle: 3.14/4,
                  child: Icon(
                  CustomIcons.phone,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}