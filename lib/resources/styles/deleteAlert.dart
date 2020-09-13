import 'package:flutter/material.dart';
import 'package:kora/core/ui/stateLessWidgets.dart/mainButton.dart';
import 'package:kora/resources/colors/colors.dart';
import 'package:kora/services/database.dart';

Function alertDialoge(BuildContext context, String sneackersId, String authorId) {
  showDialog(context: context, builder: (_) {
    return AlertDialog(
      backgroundColor: secondaryBground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.black, 
          width: 1
        )
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              'Ви впевнені, що\nхочете видалити?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 24
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: MainButton(
                    insideText: 'Ні',
                    func: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: MainButton(
                    insideText: 'Так',
                    func: () async{
                      await DatabaseService().copyToArchive(sneackersId, authorId);
                      await DatabaseService().deleteAd(sneackersId, authorId);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  });
}
