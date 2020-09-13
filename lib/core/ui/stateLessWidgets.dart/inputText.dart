import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:kora/resources/colors/colors.dart';

class InputText extends StatelessWidget {
  final TextEditingController controller;
  final String title; 
  final String attribute; 
  final List validators;
  
  InputText({
    Key key, 
    this.controller, 
    this.title, 
    this.attribute, 
    this.validators,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          maintainAnimation: true,
          maintainSize: true,
          maintainState: true,
          visible: title.isNotEmpty,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color.fromRGBO(12, 205, 230, 1),
                radius: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16
                  ),
                ),
              )
            ],
          ),
        ),
        FormBuilderTextField(
          attribute: attribute,
          controller: controller,
          maxLines: null,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(171, 180, 189, 0.3),
                width: 1
              )
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: blueColor,
                width: 1
              )
            ),
            errorBorder:  UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
                width: 1
              )
            ),
          ),
          cursorColor: blueColor,
          style: TextStyle(
            color: textColor,
            fontSize: 18
          ),
          validators: validators,
        )
      ],
    );
  }
}