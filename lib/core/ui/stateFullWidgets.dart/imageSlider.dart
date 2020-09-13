import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List images;
  ImageSlider({Key key, this.images}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Stack(
        children: [
          CarouselSlider.builder(
            options: CarouselOptions(
              enableInfiniteScroll: false,
              height: 300,
              viewportFraction: 1,
              initialPage: 0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }
            ),
            itemCount: widget.images.length,
            itemBuilder: (BuildContext context, int itemIndex) =>
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: widget.images[itemIndex].image,
                  )
                ),
              ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                int index = widget.images.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                      ? Color.fromRGBO(255, 255, 255, 0.9)
                      : Color.fromRGBO(182, 182, 182, 0.5),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}