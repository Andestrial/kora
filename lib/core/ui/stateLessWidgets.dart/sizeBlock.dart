import 'package:flutter/material.dart';
import 'package:kora/resources/colors/colors.dart';

class SizeBlock extends StatelessWidget {
  final double size;
  final double length;
  final double width;
  final String typeSize;
  
  const SizeBlock({
    Key key,
    this.size,
    this.length,
    this.width,
    this.typeSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Column(
                children: [
                  Text(
                    size.toStringAsFixed(0),
                    style: TextStyle(
                      fontSize: 22,
                      color: blueColor
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    typeSize,
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        length.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    'Довжина/см',
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        width.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 14,
                          color: textColor
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    'Ширина/см',
                    style: TextStyle(
                      fontSize: 10,
                      color: textColor
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}